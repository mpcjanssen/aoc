lines = File.readlines("input.1.txt").map &:to_i 
puts "Day1-1: #{lines.inject(0, :+)}"

require 'set'
def firstDouble(lines)
  seen = Set.new
    freq = 0
    lines.cycle do | x |
        freq = freq + x
        if seen.include? freq
            return freq
        end
        seen.add(freq) 
    end
end

puts "Day1-2: #{firstDouble(lines)}"

