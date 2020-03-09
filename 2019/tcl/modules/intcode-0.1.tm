oo::class create IntCode {
  variable Mem PC State Inputs Outputs
  constructor {program} {
    set Mem [split [string trim $program] ,]
    set PC 0
    set Inputs {}
    set Outputs {}
    set State idle
  }

  method input {in} {
    lappend Inputs $in
    if {$State eq "input-pending"} {
      set State running
    }
  }

  method outputs {} {
    return $Outputs
  }

  method mem {idx} {
    return [lindex $Mem $idx]
  }

  method setmem {idx val} {
    lset Mem $idx $val
  }

  method getval {param mode} {
    switch -exact $mode {
      0 {return [my mem $param]}
      1 {return $param}
      default {error "Unknown mode $mode"}
    }
  }

  method step {} {
    set inst [format "%05d" [lindex $Mem $PC]]
    set opcode [scan [string range $inst end-1 end]  %d]
    set mode [string range $inst 0 2]
    lassign [split $mode {}] mode3 mode2 mode1
    lassign [lrange $Mem $PC+1 end] param1 param2 param3
    set val1 [my getval $param1 $mode1]
    set val2 [my getval $param2 $mode2]
    set val3 [my getval $param3 $mode3]
    # puts "executing $opcode"
    switch -exact $opcode {
      1 {
        my setmem $param3 [expr {$val1+$val2}]
        incr PC 4
      }
      2 {
        my setmem $param3 [expr {$val1*$val2}]
        incr PC 4
      }
      3 {
        if {[llength $Inputs] == 0} {
          set State input-pending
        } else {
          set Inputs [lassign $Inputs in]
          my setmem $param1 $in
          incr PC 2
        }
      }
      4 {
        lappend Outputs $val1
        incr PC 2
      }
      5 {
        if {$val1} {
          set PC $val2
        } {
          incr PC 3
        }
      }
      6 {
        if {!$val1} {
          set PC $val2
        } {
          incr PC 3
        }
      }
      7 {
        if {$val1 < $val2} {
          my setmem $param3 1
        } {
          my setmem $param3 0
        }
        incr PC 4
      }
      8 {
        if {$val1 == $val2} {
          my setmem $param3 1
        } {
          my setmem $param3 0
        }
        incr PC 4
      }
      99 {
        set State stopped
      }
      default {
        error "Unknown opcode $opcode"
      }

    }
  }
  method run {} {
    set State running
    while {$State eq "running"} {
      my step
    }
  }
  method state {} {
    return $State
  }
}


 