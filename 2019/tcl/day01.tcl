lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package require util

set mass [read-input 01]

proc fuel {mass} {expr {$mass / 3 - 2 }}

set r1 [sum [lmap x $mass {fuel $x}]]
set r2 [sum [lmap x $mass {sum [lrange [iterate-until fuel $x neg] 1 end] }]]

puts "Part 1: $r1"
puts "Part 2: $r2"
