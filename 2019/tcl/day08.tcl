lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package require util

set data [read-input day08]

set width 25
set height 6
set layersize [expr {$width*$height}]
set pat [string repeat . $layersize]
set layers [regexp -all -inline $pat $data]

proc freq1s {d} {
  dict get $d 1
}

proc part1 {} {
  set min0freqs [lindex [lsort -integer -index 1 [lmap x $::layers {lsort -integer -stride 2 -index 0 [freq $x]}]] 0]
  return [expr {[dict get $min0freqs 1]*[dict get $min0freqs 2]}]
}

proc visualize-step {} {
  package require Tk
  wm geometry . 500x120
  canvas .c
  pack .c -fill both -expand 1
  yield
  foreach l $::layers {
    set pixels [split $l {}]
    foreach x [range 0 24] {
      foreach y [range 0 5] {
        set col [lindex $pixels [expr {$y*25+$x}]]
        if {$col eq 2} continue
        set sx [expr {$x*20+10}]
        set sy [expr {$y*20+10}]
        set sq [.c find withtag $sx:$sy]
        set color [lindex {white black} $col]
        
        if {$sq eq {}} {
            square .c $sx $sy 20 $color 
        } 
      }
    }
    # zoomcanvas .c 800 800 10
    yield 1
  }
  yield 0
}

proc visualize {} {
  every 1 visualize-step
  return
}

proc part2 {} {
  return YEHEF
}

if {$::argv0 eq [info script]} {
  visualize
}