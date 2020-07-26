tcl::tm::path add [file join [file dirname [info script]] .] {C:\Users\Mark\Sync\Notebooks\aoc\2019\tcl\modules}
package require nimtcode
package require util

set program   [read-input day02]

proc runwithinput {program in1 in2} {
    set machine [IntCode new $program]
    $machine setmem 1 $in1
    $machine setmem 2 $in2
    $machine run
    return [$machine mem 0]
} 

proc runwithinputnim {program in1 in2} {
    set machine [NimtCode $program]
    $machine setmem 1 $in1
    $machine setmem 2 $in2
    $machine run

    set val [$machine mem 0]
    rename $machine {}
    return $val
} 


proc  part1 {} { return [runwithinputnim $::program 12 2]}

proc part2 {} {
    foreach x [range 0 99] { 
        foreach y [range 0 99] {
            puts $x$y
            if { [runwithinputnim $::program $x $y] == 19690720} {
                return [expr {$x*100+$y}]
            }
        }
    }
}
puts here
set v  [NimtCode $program]
# set v  [NimtCode $program]
puts xxx$v

puts part1:\t[part1]
puts ok

puts [time part2]
puts xxx