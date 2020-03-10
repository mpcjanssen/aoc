require 'set'

DIM = 1000

# Return the claim information as [id, xrange, yrange]
def parse_claim(claim)
  cid, coords = claim.split('@')
  orig, size =  coords.split(':')
  tx, ty = orig.strip.split(',')
  tdx, tdy = size.strip.split('x')
  x1 = tx.to_i
  y1 = ty.to_i
  x2 = x1 + tdx.to_i
  y2 = y1 + tdy.to_i
  [cid, x1...x2, y1...y2 ]
end

def build_claims
  ids = Set.new
  fabric = Array.new(DIM) { Array.new(DIM) { [] } }
  claims = File.readlines('input.3.txt')
  claims.each do |claim|
    cid, rx, ry = parse_claim(claim)
    rx.each do |cx|
      ry.each do |cy|
        fabric[cx][cy] << cid.strip
        ids << cid.strip
      end
    end
  end
  [fabric, ids]
end
fabric, ids = build_claims
puts 'Day3-1:', (fabric.map { |y| y.select { |x| x.size > 1 }.size }).reduce(:+)

fabric.each do |r|
  r.each do |cell|
    if cell.size > 1
      # if cell is claimed more than once all claimants should be excluded
      cell.each { |id| ids.delete id }
    end
    if ids.size == 1
      puts 'Day3-2:', ids.first
      exit
    end
  end
end
