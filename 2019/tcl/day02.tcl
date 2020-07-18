lappend auto_path [file dirname [info script]]/lib {C:\Users\Mark\Src\site-tcl\libs-windows}
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/pintcode
package require profiler
profiler::init
package require util
package require pintcode

set program  [read-input day02]

proc runwithinput {program in1 in2} {
    set machine [PintCode $program]
    $machine setmem 1 $in1
    $machine setmem 2 $in2
    $machine run
    return [$machine mem 0]
} 





proc  part1 {} { return [runwithinput $::program 12 2]}

proc part2 {} {
    foreach x [range 0 99] { 
        foreach y [range 0 99] {
            if { [runwithinput $::program $x $y] == 19690720} {
                return [expr {$x*100+$y}]
            }
        }
    }
}

puts [time part2]
