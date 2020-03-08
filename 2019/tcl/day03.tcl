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
    return [lindex [lsort -integer -index 0 [lmap x [lintersect [line $in2] [line $in1]] {list [manhattan $x] $x}]] 1]
}

proc linesum {p l1 l2} {
    sum [list [lsearch -exact $l1 $p]  [lsearch -exact $l2 $p]]
}

proc part2 {} {
    lassign [split $::data \n] in1 in2
    set l1 [line $in1] ; set l2 [line $in2] ; set ints [lintersect $l1 $l2]
    return [lindex [lsort -integer -index 0 [lmap x $ints {list [linesum $x $l1 $l2] $x}]] 1]
}


proc addvisualsegment {start desc} {
     set dir [string index $desc 0]
     set length [string range $desc 1 end]
     lassign $start sx sy
     switch -exact $dir {
         U { set ey [expr {$sy+$length}] ; set ex $sx}
         D { set ey [expr {$sy-$length}] ; set ex $sx}
         R { set ex [expr {$sx+$length}] ; set ey $sy}
         L { set ex [expr {$sx-$length}] ; set ey $sy}
     }
     return [list $ex $ey]            
}

proc visualizeline {c input color name} {
    set current {0 0} 
    set points $current
    foreach desc [split $input , ] {
        set current [addvisualsegment $current $desc]
        lassign $current x y
        lappend points {*}$current
    }
    $c create line {*}$points -fill $color -tags $name
}


proc visualize {} {
    set pad 10
    set sx 800
    set sy 800
    set dotsize 100
    
    package require Tk
    wm geometry . ${sx}x${sy}
    destroy .c
    canvas .c
    after idle {pack .c -expand 1 -fill both}
    lassign [split $::data \n] in1 in2
    visualizeline .c $in1 red in1
    visualizeline .c $in2 green in2
    dot .c 0 0 $dotsize red
    dot .c 248 0 $dotsize blue
    dot .c 367 0 $dotsize orange
    zoomcanvas .c $sx $sy $pad
}





