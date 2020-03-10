class Left
end

class Right
end

class State
    @step = 0
    getter tail = 37
    def initialize (@recipes : Array(Int32), @elve1 : Int32, @elve2 : Int32 )
    end
    def count
        @recipes.size
    end

    def step
        r1 = @recipes[@elve1]
        r2 = @recipes[@elve2]
        result = r1+r2
        d1 = result / 10
        d2 = result % 10
        nc = @tail
        if d1 != 0
            nc = nc*10+d1
            @recipes << d1
        end
        @recipes <<  d2
        nc = nc*10+d2
        @tail = nc % (10**7)
        @elve1 = (r1+@elve1+1) % @recipes.size
        @elve2 = (r2+@elve2+1) % @recipes.size
        @step += 1
        # p @recipes
        # p @tail
        # gets
    end
    def matches?(input) 
        case 
        when input == @tail % 10**6 
            return 0
        when input == (@tail/10 % 10**6) 
            return -1
        else 
            return nil
        end
    end

    def render
        recipes = @recipes.map_with_index do | x, idx |
            case idx
            when @elve1
                "(#{x})"
            when @elve2
                "[#{x}]"
            else
                " #{x} "
            end
        end.join
        puts "#{@step} #{recipes}"
    end

    def score
        (@recipes.last(10).map &.to_s).join
    end
end

start = State.new([3,7],0,1)  

loop do
    start.step
    # start.render
    # p start.score if start.count == 9+10
    break if start.count == 846601+10
end
puts "Day14-1: #{start.score}"

start = State.new([3,7],0,1) 
loop do
    start.step
    # break if start.ends([8, 4, 6, 6, 0 ,1])

    case start.matches?(846601)
    when -1
        puts "Day14-2: #{start.count-7}"
        exit
    when 0
        puts "Day14-2: #{start.count-6}"
        exit
    else
        next

    end
    
end