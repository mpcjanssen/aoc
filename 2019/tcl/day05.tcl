lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/pintcode
package require util
package require pintcode

proc ex1 {} {
    set machine [PintCode 1002,4,3,4,33]
    $machine run
    set val [$machine mem 4]
    return $val	
}

proc part1 {} {
    set program [read-input day05]
    set machine [PintCode $program]
    $machine input 1
    $machine run
    return [list [$machine state] [$machine outputs]]
}

proc part2 {} {
    set program [read-input day05]
    set machine [PintCode $program]
    $machine input 5
    $machine run
    return [list [$machine state] [$machine outputs]]
}
