lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package require util

set input [range 231832 767346]

proc increasingdigits {x} {
    set l [split $x {}]
    return [expr {[lsort -integer $l] eq $l}]
}
 
proc part1candidates {} {
    set subs [join [lmap x [range 0 9] {list [string repeat  $x 2] {}}]]
    set candidates {}
    foreach x [lfilter $::input increasingdigits] {
        if {$x ne [string map $subs $x]} {
            lappend candidates $x
        }
    }
    return $candidates 
}

set p1candidates [part1candidates]

proc part1 {} {
    return [llength $::p1candidates]   
}

proc part2 {} {
    set candidates {}
    foreach x $::p1candidates {
        if {[lsearch [dict values [freq $x]] 2] != -1} {
            lappend candidates $x
        }
    }
    return  [llength $candidates]    
}

