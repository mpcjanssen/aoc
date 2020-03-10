def parse_file
  File.read("input.8.txt").split.map &.to_i
end

class Node
  property children, metadata
  def initialize()
    @children = Array(Node).new
    @metadata = Array(Int32).new
  end
  def add_node(n : Node)
    @children << n
  end
  def add_meta(m : Array(Int32))
    @metadata += m
  end
  def count_children()
    @children.size
  end
  def metasum()
    @metadata.sum
  end
  def sum1() : Int32
    metasum + (children.map { |n| n.sum1.as(Int32) }).sum
  end
  def sum2() : Int32
    return metasum if children.size == 0
    indexes = @metadata.select { |x| x > 0}.map {|x| x-1}
    total = 0
    indexes.each do |i|
      @children.fetch(i, nil).try do |c|
        total += c.sum2()
      end
    end
    total
  end
end

def parse_node(nums)
  n = Node.new
  # p nums
  children, metadata_size = nums.shift(2)
  # p metadata_size
  # p children, metadata_size
  children.times do
    # p "--"
    child, nums = parse_node(nums)
    n.add_node(child)
  end
  md = nums.shift(metadata_size)
  # p md
  n.add_meta(md)
  # p "==="
  # p metadata,nums
  {n, nums}
end

nums = parse_file
root,_ = parse_node(nums)

puts "8-1: #{root.sum1}"
puts "8-2: #{root.sum2}"
