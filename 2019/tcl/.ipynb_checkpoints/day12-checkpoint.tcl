lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util

proc init {moonVar} {
    upvar $moonVar moon
    set moon(1,x) 3
    set moon(1,y) 15
    set moon(1,z) 8
    set moon(1,vx) 0
    set moon(1,vy) 0 
    set moon(1,vz) 0

    set moon(2,x) 5
    set moon(2,y) -1
    set moon(2,z) -2
    set moon(2,vx) 0
    set moon(2,vy) 0 
    set moon(2,vz) 0

    set moon(3,x) -10
    set moon(3,y) 8
    set moon(3,z) 2
    set moon(3,vx) 0
    set moon(3,vy) 0 
    set moon(3,vz) 0

    set moon(4,x) 8
    set moon(4,y) 4
    set moon(4,z) -5
    set moon(4,vx) 0
    set moon(4,vy) 0 
    set moon(4,vz) 0
}

proc gravity {moonVar} {
    upvar $moonVar moon
    # Consider each pair twice
    # So both scenarios (x1 < x2) and (x2 < x1) are covered
    foreach id1 [range 1 4] {
        foreach id2 [range 1 4] {
            foreach ax {x y z} {
                if {$moon($id1,$ax) < $moon($id2,$ax)} {
                    incr moon($id1,v$ax)
                    incr moon($id2,v$ax) -1
                }
            }
        }
    }
}
proc velocity {moonVar} {
    upvar $moonVar moon
    foreach id [range 1 4] {
        foreach ax {x y z} {
            incr moon($id,$ax) $moon($id,v$ax)
        }
    }
}

proc energy {moonVar} {
    namespace import tcl::mathfunc::abs
    upvar $moonVar moon
    set total 0
    foreach id [range 1 4] {
        set kin 0
        set pot 0
        foreach ax {x y z} {
            incr pot [abs $moon($id,$ax)]
            incr kin [abs $moon($id,v$ax)]
        }
        incr total [expr {$kin*$pot}]
    }
    return $total
}

proc part1 {} {
    init space
    time {
        gravity space
        velocity space 
    } 1000
    energy space
}