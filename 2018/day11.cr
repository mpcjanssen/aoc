INPUT = 6042

SIZE = 300

def level(serial, x,y)
  rack_id = x + 10
  level = rack_id * y
  level += serial
  level *= rack_id
  hundreds  = level / 100 % 10
  level.sign * hundreds - 5
end

LEVELS = Array.new(SIZE+1) { |x| Array.new(SIZE+1) { |y| level(INPUT,x,y) }}

 
# p LEVELS


class Block
  getter powers : Array(Int32) = [0] 
  def xy
    "#{@x},#{@y}"
  end

  def max_power
    m = @powers.max
    {@powers.index(m).not_nil!, m}

  end

  def power(size)
    @powers.size < size+1 ? -999999 : @powers[size]
  end

  def initialize(@x : Int32,@y : Int32)
    # p "--------------------"
    # p xy
    init_powers
  end
  def init_powers
    max_size = [SIZE-@x, SIZE-@y].min+1
    # p xy
    # p max_size
    (1..max_size).each do |size|
      # p size
      # p "+++++++++"
      # p "#{max_size} --- #{size}"
      total = @powers[size-1]
      (@x...(@x+size-1)).each do |x| 
        # p "#{x}, #{@y+size-1}"
        total += LEVELS[x][@y+size-1]
      end
      (@y...(@y+size-1)).each do |y| 
        # p "#{@x+size-1}, #{y}"
        total += LEVELS[@x+size-1][y]
      end
      last = LEVELS[@x+size-1][@y+size-1]
      # p last
      total += last
      @powers << total
    end
    # p @powers

  end
end

blocks = Array(Block).new
(1..SIZE).each do |x|
  (1..SIZE).each do |y|
    blocks << Block.new(x,y)
  end
end

puts "Day11-1: #{(blocks.sort_by &.power(3)).last.xy}"
block = blocks.max_by &.max_power[1]
puts "Day11-2: #{block.xy} size: #{block.max_power[0]}"
