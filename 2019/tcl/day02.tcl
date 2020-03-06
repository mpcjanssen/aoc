lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package require util
package require intcode

set program [split [string trim [read-input day02]] ,]

set machine [IntCode new [lreplace $program 1 2 12 2]]

$machine run

set r1 [$machine mem 0] 
set r2 {}

puts "Part 1: $r1"
puts "Part 2: $r2"
