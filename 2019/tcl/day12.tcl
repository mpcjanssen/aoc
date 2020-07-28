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

proc gravity {moonVar axes}  {
    upvar $moonVar moon
    # Consider each pair twice
    # So both scenarios (x1 < x2) and (x2 < x1) are covered
    foreach id1 [range 1 4] {
        foreach id2 [range 1 4] {
            foreach ax $axes {
                if {$moon($id1,$ax) < $moon($id2,$ax)} {
                    incr moon($id1,v$ax)
                    incr moon($id2,v$ax) -1
                }
            }
        }
    }
}
proc velocity {moonVar axes} {
    upvar $moonVar moon
    foreach id [range 1 4] {
        foreach ax $axes {
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

proc step {moonVar axes} {
    upvar $moonVar space
    gravity space $axes
    velocity space $axes
}

proc part1 {} {
    init space
    time {step space {x y z}} 1000
    energy space
}


proc ininitial {moonVar startVar periodsVar axesVar step} {
    upvar $moonVar moon
    upvar $startVar start
    upvar $periodsVar periods
    upvar $axesVar axes
    foreach ax $axes {
        if {[dict exists $periods $ax]} continue
        set same 1
        foreach id {1 2 3 4} {
           if { $moon($id,$ax) != $start($id,$ax) || 
                $moon($id,v$ax) != $start($id,v$ax) } {
                set same 0
                break 
               }
       }
       if ($same) {
            dict set periods $ax $step
            set axes [lsearch -all -inline -not $axes $ax]
            puts $axes
       }
   }
}

proc periods {} {
    set axes {x y z}
    init start
    init space
    set i 0
    set periods {}
    while {true} {
        step space $axes
        incr i

        ininitial space start periods axes $i
        if {[llength $periods] == 6} {
            # puts [lsort -stride 2 $periods]
            # puts [llength [dict values $periods]]
            return [dict values $periods]
        } 
    }

}


proc factors {n} {
    set top $n
    set factor 2
    set factors {}
    # puts "########## $n"
    while {$factor <= $top && $n != 1} {
        # puts "$n : $factor < $top"
        if {$n % $factor == 0} {
            dict incr factors $factor
            set n [expr {$n / $factor}]
        } else {
            incr factor
        }
    }
    # puts "<<<<<<<<< $factors"
    return $factors
}

proc part2 {} {
    namespace import tcl::mathop::*
    set total_factors {}
    puts [time {set periods [periods]}]
    foreach period $periods {
        set f [factors $period]
        # puts $f
        foreach k [dict keys $f] {
            # puts $k
            if {![dict exists $total_factors $k] || [dict get $f $k] > [dict get $total_factors $k]} {
                dict set total_factors $k [dict get $f $k] 
            }
        }
    }
    set factors {}
    # puts $total_factors
     foreach {factor count} $total_factors {
        lappend factors {*}[lrepeat  $count $factor]
     }
     return [* {*}$factors]
}

proc visualize {} {
    init space
    
    
    set pad 10
    set sx 800
    set sy 800
    package require Tk
    wm geometry . ${sx}x${sy}
    canvas .c
    
    set ::e ""
    label .l -textvariable  ::e
    label .p1 -textvariable  ::p1
    grid .p1 -sticky ew
    grid .l -sticky ew
    grid .c -sticky nsew  
    grid rowconfigure . .c -weight 1
    grid columnconfigure . 0 -weight 1
    
    
    
    
    set dotsize 10
    set cols {_ red blue orange green}
    foreach id [range 1 4] {
    	dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize [lindex $cols $id] id$id
    }
    set i 0
    while {1} {
        gravity space
      #   foreach id [range 1 4] {
    		# .c move id$id $space($id,vx) $space($id,vy)
      #   }
      .c delete all
      foreach id [range 1 4] {
        dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize [lindex $cols $id] id$id
    }
    velocity space
    incr i

    set ::e "Energy: [energy space]"
    if {$i == 1000} {set ::p1 "Part1: $::e"}

        # if {$i % 500 == 0 } {
        #     .c delete checks
        #     foreach id [range 1 4] {
        #         dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize black checks
        #     }
        # }
        after 30	
        update
    }
    
}

if {$::argv0 eq [info script]} {
    visualize
}

