# File Header has the following structure 
#		TABLE
#		0,1
#		""	

# The number of rows comes after "VECTORS"
#		VECTORS
#		0,21      <--- Second value
#		""	

# The number of rows comes after "TUPLES"
#		TUPLES
#		0,26032   <--- Second value
#		""	

# Data marker. This is a 4 line structure that signals the begining of the DATA section
#		DATA
#		0,0
#		""

# BOT Begining of Tuple. Actual data starts after this two line stucture.
#		-1,0
#		BOT

require "dif/version"
require "dif/line_helpers"
require "csv"

module Dif
	class Reader
		attr_reader :rows_count, :column_count, :lines, :csv
		ALLOWED_COMMANDS = %w(EOD BOT)

		def initialize(file, encoding="IBM850")
			@lines = ::File.read(file, :external_encoding => encoding, :internal_encoding => "UTF-8").lines
			@csv = CSV.new("", col_sep: "\t")
			@line_buffer=Array.new
			fix_lines
			set_rows
			set_columns
			@lines.slice! 0..data_section_start_at_line
			read_data
		end
		
		def export_csv
			@csv.string
		end

		private

		def set_rows
			# find the line with VECTORS, move to the next, split, get last item, convert to integer and save in instance variable.
			vector_line =lines.index("VECTORS")
			@rows_count = lines[vector_line.next].split(",").last.to_i 
		end

		def set_columns
			# find the line with TUPLES, move to the next, split, get last item, convert to integer and save in instance variable.
			tuple_line = lines.index("TUPLES")
			@column_count = lines[tuple_line.next].split(",").last.to_i
		end

		def data_section_start_at_line
			@data_section_start_at_line ||= lines.index("DATA")
		end

		def read_data
			@lines.slice! 0..lines.index("BOT")  # remove everything up to first BOT
			lines.each_with_index do |line,index|   #iterate over data section
				# only looking for lines in the form of -1,15 (two digits with a comma between)
				line_eval = /(?<command>-*\d),(?<value>\d+)/.match(line) 
				next if not line_eval 
				
				case line_eval[:command]
				when "-1"
					process_command(index)
				when "0" #value
					@line_buffer << line_eval[:value].to_i
				when "1"
					@line_buffer << lines[index.next].sub(/^"/,"").sub(/"$/,"")
				end

			end
		end


		def process_command(index)
			command = lines[index.next]
			raise "Command not in allowed list" if !ALLOWED_COMMANDS.include? command
		
			csv << @line_buffer if !@line_buffer.empty?
		
			case command
			when "BOT"
				@line_buffer.clear
			when "EOD"
				return
			end
		end

	
	end
end
