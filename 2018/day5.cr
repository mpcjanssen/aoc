polymer = File.read("input.5.txt").chomp

def anti(x, y)
  x != nil && x != y && x.upcase == y.upcase
end

def poly_reduce(p, ignore = "")
  p = p.tr(ignore, "")
  res = [] of Char
  p.each_char do |c|
    if res.size > 0 && anti(res[-1], c)
      res.pop
    else
      res << c
    end
  end
  res
end

puts "5-1: #{poly_reduce(polymer).size}"

experiments = ('a'..'z').map do |x|
  {poly_reduce(polymer, x.to_s + x.to_s.upcase).size, x.to_s}
end
puts "5-2: #{experiments.sort.first[0]}"
