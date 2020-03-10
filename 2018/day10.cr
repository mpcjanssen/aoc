input = <<-TEST
position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
TEST

class Particle
  getter x,y
  def initialize(@x : Int32,@y : Int32,@vx : Int32, @vy : Int32)
  end
  def neighbour(other)
    case 
    when @x == other.x
      return (@y-other.y).abs == 1
    when @y == other.y
      return (@x-other.x).abs == 1
    else return false
    end
  end
  def step
    @x += @vx
    @y += @vy
  end
end

class SkyView
  @time = 0
  @particles = Array(Particle).new
  def initialize(input)
    input.lines.each do |l|
      # p l
      /<\s*([-0-9]+),\s*([-0-9]+)>.*<\s*([-0-9]+),\s*([-0-9]+)>/.match(l).try do |m|
        # p "-------"
        @particles << Particle.new(m[1].to_i,m[2].to_i, m[3].to_i,m[4].to_i)
      end
    end
    # p @particles.size      
  end
  def step
    @particles.each &.step
  end
  def run
    loop do
    # puts "t: #{@time}, coherence: #{coherent?}" if @time % 1000 == 0
    if coherent?
      render
      puts "Press <enter> for next coherent sample or x<enter> to break"
      break if gets == "x"
    end
    step
    @time += 1
    end
  end
  def coherent?
    min_y, max_y = (@particles.map &.y).minmax
    max_y - min_y < 12
  end
  # def coherence
  #   ns = (@particles.map { |x| neighbours(x).size })
  #   # p ns
  #   ns.sum.to_f / ns.size
  # end
  def neighbours(particle)
    @particles.select { |other| particle.neighbour(other)}
  end
  def render
    min_x, max_x = (@particles.map &.x).minmax
    min_y, max_y = (@particles.map &.y).minmax
    puts "t: #{@time}, coherence: #{coherent?}"
    (min_y..max_y).each do |y|
      line = Array(String).new
      (min_x..max_x+1).each do |x|
        if (@particles.select {|p| p.x == x && p.y == y}).size > 0
          line << "#"
        else
          line << " "
        end
      end
      puts line.join  
    end
  end
end

SkyView.new(input).run
SkyView.new(File.read("input.10.txt")).run