oo::class create IntCode {
  variable Mem PC Base State Inputs Outputs
  constructor {program} {
    set Mem {} 
    set idx 0
    foreach val [split [string trim $program] ,] {
      dict set Mem $idx $val
      incr idx
    } 
    set PC 0
    set Base 0
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
    return [getdef $Mem $idx 0]
  }

  method setmem {idx val} {
    dict set Mem $idx $val
  }

  method getval {param mode} {
    switch -exact $mode {
      0 -
      2 {return [my mem [my getaddress $param $mode]]}
      1 {return $param}
      default {error "Unknown mode $mode"}
    }
  }

  method getaddress {param mode} {
    switch -exact $mode {
      0 {return $param}
      2 {return  [expr {$param+$Base}]}
      default {error "Unknown  address mode $mode"}
    }
  }

  method step {} {
    set inst [format "%05d" [my mem $PC]]
    set opcode [scan [string range $inst end-1 end]  %d]
    set mode [string range $inst 0 2]
    set param1 [my mem [expr {$PC+1}]]
    set param2 [my mem [expr {$PC+2}]]
    set param3 [my mem [expr {$PC+3}]]
    lassign [split $mode {}] mode3 mode2 mode1
    set val1 [my getval $param1 $mode1]
    set val2 [my getval $param2 $mode2]
    # puts "executing $opcode"
    switch -exact $opcode {
      1 {
        my setmem [my getaddress $param3 $mode3] [expr {$val1+$val2}]
        incr PC 4
      }
      2 {
        my setmem [my getaddress $param3 $mode3] [expr {$val1*$val2}]
        incr PC 4
      }
      3 {
        if {[llength $Inputs] == 0} {
          set State input-pending
        } else {
          set Inputs [lassign $Inputs in]
          my setmem [my getaddress $param1 $mode1] $in
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
          my setmem  [my getaddress $param3 $mode3] 1
        } {
          my setmem  [my getaddress $param3 $mode3] 0
        }
        incr PC 4
      }
      8 {
        if {$val1 == $val2} {
          my setmem [my getaddress $param3 $mode3] 1
        } {
          my setmem [my getaddress $param3 $mode3] 0
        }
        incr PC 4
      }
      9 {
        incr Base $val1
        incr PC 2
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


 