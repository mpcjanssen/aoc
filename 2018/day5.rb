polymer = File.read('input.5.txt').chomp
def anti(unit1, unit2)
  unit1 != unit2 && unit1.casecmp(unit2).zero?
end

def poly_reduce(poly, ignore = '')
  poly = poly.tr(ignore, '')
  res = []
  poly.split('').each do |c|
    if !res.empty? && anti(res[-1], c)
      res.pop
    else
      res << c
    end
  end
  res
end
puts "5-1: #{poly_reduce(polymer).size}"

experiments = ('a'..'z').map do |x|
  [poly_reduce(polymer, x + x.upcase).size, x]
end
puts "5-2: #{experiments.min[0]}"
