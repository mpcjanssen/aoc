class Req
  getter req, step

  def initialize(@req : String, @step : String)
  end
end

def parse_file
  reqs = Array(Req).new
  File.read_lines("input.7.txt").each do |l|
    /Step (.).*step (.)/.match(l).try do |m|
      reqs << Req.new(m[1], m[2])
    end
  end
  reqs
end

reqs = parse_file.sort_by(&.req)
steps = (reqs.map &.req + reqs.map &.step).uniq
wip = Array(String).new
elves_in_progess = Array(Bool).new(5)
order = Array(String).new
while order.size < steps.size
  steps_left = steps - order
  # p "l",steps_left
  steps_with_reqs = reqs.map &.step
  available = (steps - order) - steps_with_reqs
  # p "a", available
  order << available.first
  reqs = reqs.reject { |r| order.includes? r.req }
  # p reqs
end
p order.join
