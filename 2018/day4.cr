lines = File.read_lines("input.4.txt").sort

class SleepInfo
  getter guard_id, sleeping

  def initialize(@guard_id : String)
    @sleeping = Array(Int32).new(60) { |j| j = 0 }
  end

  def addSleep(range)
    range.each { |min| @sleeping[min] = 1 }
  end
end

sleepInfo = Array(SleepInfo).new

sI : SleepInfo | Nil = nil
start = 0
lines.each do |l|
  # p l

  /Guard (#[0-9]+) begins/.match(l).try do |m|
    sI = SleepInfo.new m[1]
    # p "#{m[1]} starts"
    sleepInfo << sI
    next
  end
  /00:([0-9]+).*asleep/.match(l).try do |m|
    start = m[1].to_i
    next
  end
  /00:([0-9]+).*wakes/.match(l).try do |m|
    # p "Slept from #{start} to #{m[1]}"
    sleepInfo[-1].addSleep(start...m[1].to_i)
    next
  end
end

sleep_by_guard = sleepInfo.group_by &.guard_id
sleepiest = sleep_by_guard.map { |x| {(x[1].map &.sleeping.sum).sum, x[0]} }.sort.last[1]
p sleepiest
sleep_per_minute = (sleep_by_guard[sleepiest].map &.sleeping).transpose.map &.sum
most_slept = sleep_per_minute.max
minute = sleep_per_minute.index(most_slept).not_nil!
p minute
numid = sleepiest.lchop("#").to_i
p (minute * numid)

guards_min_sleep = sleep_by_guard.map { |x| {x[0], (x[1].map &.sleeping).transpose.map &.sum} }

max, id = guards_min_sleep.map { |x| {x[1].max, x[0]} }.sort.last

p id
sleep = guards_min_sleep.find { |x| x[0] == id }.not_nil![1]
minute = sleep.index(max).not_nil!
p minute

numid = id.lchop("#").to_i
p (minute * numid)
