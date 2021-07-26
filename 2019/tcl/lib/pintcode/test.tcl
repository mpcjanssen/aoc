tcl::tm::path add [file join [file dirname [info script]] .] {/home/mpcjanssen/Src/aoc/2019/tcl/modules/}
package require pintcode
package require util

set program  [read-input day02]

proc runwithinput {program in1 in2} {
    set machine [IntCode new $program]
	puts 2 
    $machine setmem 1 $in1
	puts 3 
    $machine setmem 2 $in2
	puts 4 
    $machine run
	puts 5 
    return [$machine mem 0]
} 

proc runwithinputpascal {program in1 in2} {
    set machine [PintCode $program]
    $machine setmem 1 $in1
    $machine setmem 2 $in2
    $machine run
    set val [$machine mem 0]
    rename $machine {}
    return $val
} 


proc  part1 {} { return [runwithinputpascal $::program 12 2]}

proc part2 {} {
    foreach x [range 0 99] { 
        foreach y [range 0 99] {
            if { [runwithinputpascal $::program $x $y] == 19690720} {
                return [expr {$x*100+$y}]
            }
        }
    }
}

puts ok

puts part1:\t[part1]
puts part2:\t[part2]
puts [time part1]

puts [time part2]

