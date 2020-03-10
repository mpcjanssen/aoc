require "big"

TEST_START = "##..##....#.#.####........##.#.#####.##..#.#..#.#...##.#####.###.##...#....##....#..###.#...#.#.#.#"
RULES = <<-END
##.#. => .
##.## => .
#..## => .
#.#.# => .
..#.. => #
#.##. => .
##... => #
.#..# => .
#.### => .
..... => .
...#. => #
#..#. => #
###.. => #
.#... => #
###.# => #
####. => .
.##.# => #
#.#.. => #
.###. => #
.#.## => .
##### => #
....# => .
.#### => .
.##.. => #
##..# => .
#...# => .
..### => #
...## => .
#.... => .
..##. => .
.#.#. => #
..#.# => #
END

# This can be discovered by experimenting
REPEATING =  [0, 1, 5, 6, 10, 11, 15, 16, 20, 21, 25, 26, 30, 31, 35, 36, 40, 41, 45, 46, 50, 51, 55, 56, 60, 61, 65, 66, 70, 71, 75, 76, 80, 81, 85, 86, 90, 91, 95, 96, 100, 101, 105, 106, 110, 111, 115, 116, 120, 121, 125, 126, 130, 131, 135, 136, 140, 141, 145, 146, 150, 151, 155, 156, 160, 161, 165, 166, 170, 171, 175, 176, 180, 181, 185, 186, 190, 191, 195, 196]
  

class Pots
  @deltas = Array(Int32).new
  @min_pot = 0
  def initialize(start : String , @rules : Array(Rule))
    start.each_char_with_index do |char,idx|
      @deltas << idx if char == '#'
      @min_pot = @deltas.min
      @deltas = @deltas.map {|x| x - @min_pot}
    end
  end

  def filled?(id)
    @deltas.includes?(id-@min_pot) 
  end

  def charat(id)
    filled?(id) ? '#' : '.'
  end

  def sum
    @deltas.map {|x| x + @min_pot}.sum
  end

  def minmax
    # p @pots
    @deltas.minmax.map {|x| x+@min_pot}
  end

  ## Return the environments for all the pots to consider
  def env(id)
    env = Array(Char).new
    (-2..2).each do | offset |
      # p offset+id+4
      env << charat(offset+id)
    end
    {id, env.join}
  end
  def envs
    startid,endid = minmax
    startid-=2
    endid+=2
    # p startid
    # p endid
    (startid..endid).map do |id|
      # p id
      env(id)
    end
  end
  def render
    puts "#{@min_pot} #{@deltas}"
    
  end


  def nextgen()
    # p @pots
    # p envs
    # p @rules
    if @deltas == REPEATING
      # p sum
      # p "repeating"
      @min_pot += 1
      return true 
    end
    newpots = Array(Int32).new
    # p envs
    envs.map do |id, e|
      m = @rules.find do |r|
        r.matches(e)
      end
      newpots << id if m && m.result == '#'
    end
    # p newpots
    @min_pot = newpots.min
    # p @min_pot
    # p sum
    @deltas = newpots.map {|x| x - @min_pot}
    return false
  end
end

class Rule
  getter result
  def initialize(@mask : String, @result : Char)
  end
  def matches(env : String)
    # p @mask
    # p env
    # p @mask == env
    # p "matched" if @mask == env
    @mask == env
  end
end


rules = RULES.each_line.map do |l|
  mask, result = l.split(" => ")
  Rule.new(mask,result[0])
end

pots = Pots.new(TEST_START, rules.to_a)

gen = 0 
MAX_GENS = 50000000000
while gen < MAX_GENS
  gen+=1
  if pots.nextgen
    total = BigInt.new(pots.sum)
    puts "Day 12-2: #{total+(MAX_GENS-gen)*80}" 
    exit
  end
  puts "Day 12-1: #{pots.sum}" if gen == 20
end





