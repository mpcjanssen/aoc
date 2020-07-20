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
  foreach l [lreverse $::layers] {
    set pixels [split $l {}]
    foreach x [range 0 24] {
      foreach y [range 0 5] {
        set col [lindex $pixels [expr {$y*25+$x}]]
        set sx [expr {$x*20+10}]
        set sy [expr {$y*20+10}]
        switch $col {
          0 {square .c $sx $sy 20 black}
          1 {square .c $sx $sy 20 white}
        }
      }
    }
    # zoomcanvas .c 800 800 10
    yield 1
  }
  yield 0
}

proc visualize {} {
  every 100 visualize-step
  return
}

proc part2 {} {
  return YEHEF
}

if {$::argv0 eq [info script]} {
  visualize
}