lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package require util
package require intcode

proc ex1 {} {
    set machine [IntCode new 1002,4,3,4,33]
    $machine run
    return [$machine mem 4]
}

