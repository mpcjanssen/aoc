lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package require util
package require intcode


set data [read-input day03]

proc line {input} {
    set line {{0 0}} 
    foreach desc [split $input , ] {
        addsegment line $desc
    }
    return $line
}



proc addsegment {lineVar desc} {
     upvar $lineVar line
     set dir [string index $desc 0]
     set length [string range $desc 1 end]
     set start [lindex $line end]
     lassign $start sx sy
     switch -exact $dir {
         U {
             foreach _ [range 1 $length] {
                 incr sy
                 lappend line [list $sx $sy]
             }
         }
         D {
             foreach _ [range 1 $length] {
                 incr sy -1
                 lappend line [list $sx $sy]
             }
         }
        R {
             foreach _ [range 1 $length] {
                 incr sx
                 lappend line [list $sx $sy]
             }
         }
        L {
             foreach _ [range 1 $length] {
                 incr sx -1
                 lappend line [list $sx $sy]
             }
         }
     }
}



proc part1 {} {
    lassign [split $::data \n] in1 in2
    return [lindex [lsort -integer -index 0 [lmap x [lintersect [line $in2] [line $in1]] {list [manhattan $x] $x}]] 1 0]
}

proc part2 {} {
    lassign [split $::data \n] in1 in2
    set l1 [line $in1] ; set l2 [line $in2] ; set ints [lintersect $l1 $l2]
    return [lindex [lsort -integer [lmap d [lmap p $ints {list [lsearch -exact $l1 $p]  [lsearch -exact $l2 $p]}] {sum $d}]] 1]
}





