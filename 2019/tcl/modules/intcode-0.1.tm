oo::class create IntCode {
  variable Mem PC Signal
  constructor {program} {
    set Mem [split [string trim $program] ,]
    set PC 0
    set Signal {}
  }

  method mem {idx} {
    return [lindex $Mem $idx]
  }

  method setmem {idx val} {
    lset Mem $idx $val
  }

  method step {} {
    set opcode [lindex $Mem $PC]
    set data [lrange $Mem $PC+1 end]
    # puts "executing $opcode"
    switch -exact $opcode {
      1 {
        lassign $data xpos ypos to
        set x [lindex $Mem $xpos]
        set y [lindex $Mem $ypos]
        lset Mem $to [expr {$x+$y}]
        incr PC 4
      }
      2 {
        lassign $data xpos ypos to
        set x [lindex $Mem $xpos]
        set y [lindex $Mem $ypos]
        lset Mem $to [expr {$x*$y}]
        incr PC 4
      }
      99 {set Signal stopped}
      default {
        error "Unknown opcode $opcode"
      }

    }
  }
  method run {} {
    while {$Signal ne "stopped"} {
      my step
    }
  }
}


