DIM = 1000

IDS = Set(String).new

def build_claims
  fabric = Array.new(DIM) { |i| Array.new(DIM) { |j| Array(String).new } }
  claims = File.read_lines("input.3.txt")
  claims.each do |claim|
    cid, coords = claim.split("@")
    orig, size = coords.split(":")
    tx, ty = orig.strip.split(",")
    tdx, tdy = size.strip.split("x")
    x, y = tx.to_i, ty.to_i
    dx, dy = tdx.to_i, tdy.to_i
    (x...(x + dx)).each do |x|
      (y...(y + dy)).each do |y|
        fabric[x][y] << cid.strip
        IDS << cid.strip
      end
    end
  end
  fabric
end

fabric = build_claims
puts "Day3-1:", (fabric.map &.select { |x| x.size > 1 }.size).sum

fabric.each do |r|
  r.each do |cell|
    if cell.size > 1
      # if cell is claimed more than once all claimants should be exluded
      cell.each { |id| IDS.delete id }
    end
    if IDS.size == 1
      puts "Day3-2:", IDS.first
      exit
    end
  end
end
