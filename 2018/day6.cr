class Point
  @id : String
  @x : Int32
  @y : Int32
  getter id, x, y

  def initialize(@id : String, line : String)
    @x, @y = line.split(",").map &.to_i.not_nil!
  end

  def initialize(@x, @y)
    @id = ""
  end

  def distance(p)
    (self.x - p.x).abs + (self.y - p.y).abs
  end

  def distances(points)
    points.map { |other| {other, self.distance(other)} }
  end

  def closest(points : Array(Point))
    d = distances(points)
    min = d.min_by &.[1]
    d.select { |d| d[1] == min[1] }.map &.[0]
  end
end

def parse_file
  points = [] of Point
  File.read_lines("input.6.txt").each_with_index do |l, idx|
    points << Point.new("pt#{idx}", l)
  end
  points
end

points = parse_file
max_x = (points.max_by &.x).x
max_y = (points.max_by &.y).y

grid = Array.new(max_x) { Array.new(max_y, "") }
# p max_x
# p max_y
grid.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    closest = Point.new(x, y).closest(points)
    owner = closest.size == 1 ? closest[0].id : "."
    grid[x][y] = owner
  end
end
t = grid.transpose
max_area = ((grid.flatten - (grid[0] + grid[-1] + t[0] + t[-1]).uniq).group_by { |x| x }.map { |id, ids| {id, ids.size} }.max_by &.[1])[1]
puts "Day6-1: #{max_area}"

MAX = 10000
grid = Array.new(max_x) { Array.new(max_y, 0) }
grid.each_with_index do |row, x|
  row.each_with_index do |cell, y|
    grid[x][y] = Point.new(x, y).distances(points).sum &.[1]
  end
end

puts "Day6-1: #{grid.flatten.select { |x| x < MAX }.size}"
