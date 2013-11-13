# These methods are a set of private methods that extends capabilities

module Dif
	class Reader
		private
		def fix_lines
			@lines.map! do |line|
				line.chomp!
			end
		end

		
	end
end