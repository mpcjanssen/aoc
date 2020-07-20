tcl::tm::path add [file join [file dirname [info script]] .] {C:\Users\Mark\Sync\Notebooks\aoc\2019\tcl\modules}
package require pintcode
package require util

set program  [read-input day02]

proc runwithinput {program in1 in2} {
    set machine [IntCode new $program]
    $machine setmem 1 $in1
    $machine setmem 2 $in2
    $machine run
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
set v  [PintCode $program]
set w  [PintCode $program]
puts zzz$v

puts part1:\t[part1]
puts part1:\t[part2]
puts [time part1]

puts [time part2]

