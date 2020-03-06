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
 