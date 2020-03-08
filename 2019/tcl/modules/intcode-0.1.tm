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

  method getval {param mode} {
    switch -exact $mode {
      0 {return [my mem $param]}
      1 {return $param}
      default {error "Unknown mode $mode"}
    }
  }

  method step {} {
    set inst [format "%05d" [lindex $Mem $PC]]
    set opcode [format %d [string range $inst end-1 end]]
    set mode [string range $inst 0 2]
    lassign [split $mode {}] mode1 mode2 mode3
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


