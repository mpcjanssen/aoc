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

proc step {moonVar} {
    upvar $moonVar space
    gravity space
    velocity space 
}

proc part1 {} {
    init space
    time {step space} 1000
    energy space
}




proc visualize {} {
    init space
    
    
    set pad 10
    set sx 800
    set sy 800
    package require Tk
    wm geometry . ${sx}x${sy}
    canvas .c
    
    label .l -textvariable  e
    pack .c -expand 1 -fill both
   

    set dotsize 10
    set cols {_ red blue orange green}
    foreach id [range 1 4] {
    	dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize [lindex $cols $id] id$id
    }
    set i 0
    while {1} {
	gravity space
        foreach id [range 1 4] {
    		.c move id$id $space($id,vx) $space($id,vy)
    	}
	velocity space
	incr i
	
	set e [energy space]
	if {$i == 1000} {puts $e}
	after 30	
        update
    }

}

if {$::argv0 eq [info script]} {
  visualize
}

