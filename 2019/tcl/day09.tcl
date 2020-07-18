lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules  [file dirname [info script]]/lib/pintcode
package require util

package require intcode
interp alias {} PintCode {} IntCode new
package require pintcode 


proc ex1 {} {
    set program 109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99
    set machine [PintCode $program]
    $machine run
    return [list [$machine state] [$machine outputs]]
}

proc ex2 {} {
    set program 1102,34915192,34915192,7,4,7,99
    set machine [PintCode $program]
    $machine run
    return [list [$machine state] [$machine outputs]]
}

proc part1 {} {
    set program [read-input day09]
puts $program
    set machine [PintCode $program]
    $machine input 1
    $machine run
    return [list [$machine state] [$machine outputs]]
}

proc part2 {} {
    set program [read-input day09]
puts $program
    set machine [PintCode $program]
    $machine input 2
    $machine run
    return [list [$machine state] [$machine outputs]]
}
