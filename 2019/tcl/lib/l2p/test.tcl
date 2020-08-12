load cmake-build-debug/libl2p.dll L2p

puts [time {set result [l2p {U5 L4 D5} {R5 U4 L3}]}]

puts "result: $result"
