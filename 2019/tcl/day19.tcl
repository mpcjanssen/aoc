lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode




proc part1 {} {
    set program [read-input day19]
    set results {}
    foreach x [range 0 49] {
	foreach y [range 0 49] {
	    set machine [CintCode [split $program ,]]
	    $machine input $x
	    $machine input $y
	    $machine run
	    set result [lindex [$machine outputs] end]
	    lappend results $result
	    rename $machine {}
	}
    }
    return [sum $results]
}

proc part2 {} {
    set program [read-input day19]
    set machine [CintCode [split $program ,]]
}

proc visualize {} {
    package require Tk
    wm geometry . 550x550
    canvas .c
    pack .c -expand 1 -fill both
    set program [read-input day19]
    foreach x [range 0 49] {
	foreach y [range 0 49] {
	    set machine [CintCode [split $program ,]]
	    $machine input $x 
	    $machine input $y 
	    $machine run
	    set result [lindex [$machine outputs] end]
	    if {$result == 1} {
		square .c [expr {$x*10+10}]  [expr {$y*10+10}] 10 green
	    }
	    
	}
    }
}


if {$::argv0 eq [info script]} {
  visualize
}
