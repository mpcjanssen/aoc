require "big"

NUM_PLAYERS = 476i64
LAST_POINTS = 71431i64

class Game
  @circle = Deque(Int64).new(1) {|j| j =0i64}
  def initialize(num_players, @last_marble : Int64 )
    @scores = Array(Array(Int64)).new(num_players) { |j| j = Array(Int64).new}
  end
  def play()
    current_marble = 1i64
    until current_marble > @last_marble
      play_next(current_marble)
      current_marble+=1
    end
    return @scores
  end
  def player_for_turn(turn)
    (turn-1) % @scores.size + 1 
  end
  def play_next(marble : Int64)
    player = player_for_turn(marble)
    # puts "Turn #{marble}: player #{player_for_turn(marble)}"
    if (marble % 23 !=0)
      @circle.rotate!
      @circle.push(marble)
    else
      # p @circle
      @circle.rotate!(-7)
      # p @circle
      extra = @circle.pop
      @circle.rotate!
      # p @circle
      @scores[player-1]<<=marble+extra
    end
  end
end

# p PlayState.new(9,25).play.max
# p PlayState.new(30,5807).play.max
puts "Day 9-1: #{(Game.new(NUM_PLAYERS,LAST_POINTS).play.map &.sum).max}"
t = (Game.new(NUM_PLAYERS,LAST_POINTS*100).play.map do |nums|
  nums.map { |n| BigInt.new(n) }.sum 
end)

puts "Day 9-2: #{t.max}"