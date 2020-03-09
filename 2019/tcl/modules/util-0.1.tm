set dir [file normalize [file dirname [info script]]]

proc iterate-until {f x px} { 
  set res {}
  while {![{*}$px $x]} {
    lappend res $x
    set x [{*}$f $x]
  }
  return $res
}
proc iterate-while {f x px} { 
  set res {}
  while {[{*}$px $x]} {
    lappend res $x
    set x [{*}$f $x]
  }
  return $res
}

proc sum {l} {tcl::mathop::+ {*}$l}

proc neg {x} {return [expr {$x < 0}]}

proc read-input {day} {
   set f [open $::dir/../../input/${day}.txt]
   set d [read $f]
   close $f
   return $d
}

proc range {start end} {
  set res {}
  for {set i $start} {$i < $end+1} {incr i} {
    lappend res $i
  }
  return $res
}

proc manhattan {p} {
    lassign $p x y
    return [expr {abs($x)+abs($y)}]
}

proc lintersect { a b } {
    set a [lsort $a]
    set result {}
    foreach element $b {
        if { [lsearch -sorted -increasing $a $element] != -1 } {
            lappend result $element
        }
    }
    return $result
}

 proc ldifference {a b} {
        if {[llength $a] == 0} {
            set ret $b
        } elseif {[llength $b] == 0} {
            set ret $a
        } else {
            foreach key $a {set ary($key) ""}
            set ret {}  
            foreach key $b {
                if {[info exist ary($key)]} {
                    unset ary($key)
                } {
                    lappend ret $key
                }
            }
            foreach key [array names ary] {lappend ret $key}
            # AK ?speed: eval lappend ret [array names ary]
        }
        set ret
    }

proc zoomcanvas {c sx sy pad} {
    lassign [$c bbox all] minx miny maxx maxy

    set s [expr {abs(($sx-2.0*$pad)/($maxx-$minx))}]
    set s2 [expr {abs(($sy-2.0*$pad)/($maxy-$miny))}]
    if {$s2 < $s} {set s $s2}

    $c move all [expr {-$minx}]  [expr {-$miny}]
    $c scale all 0 0 $s $s
    $c move all $pad $pad
}
 
 proc dot {c x y size color} {
   set size [expr {$size/2.0}]
    $c create oval [expr {$x-$size}] [expr {$y-$size}]  [expr {$x+$size}] [expr {$y+$size}] -fill $color

}

proc lfilter {l pred} {
  set res {}
  foreach e $l {
    if {[$pred $e]} {
      lappend res $e
    }
  }
  return $res
} 