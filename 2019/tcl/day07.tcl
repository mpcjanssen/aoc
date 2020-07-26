lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package forget util
package require util
package forget intcode
catch {rename IntCode {}}
package require cintcode

set program [split [read-input day07] ,]

proc dosimul {phases} {
    set lastout 0
    set machines {}
    foreach ph $phases  {
        set machine [CintCode $::program]
        $machine input $ph
        lappend machines $machine
    }
    set lastout 0
    while {[[lindex $machines end] state] ne "stopped"} {
        foreach m $machines {
            $m input $lastout
            $m run
            set lastout [lindex [$m outputs] end]
        }
    }
    return $lastout
}


proc part1 {} {
    set res {}
    foreach perm [permutations [range 0 4]] {
        lappend res [dosimul $perm]
    }
    return [lindex [lsort -decreasing -integer $res ] 0]
}

proc part2 {} {
    set res {}
    foreach perm [permutations [range 5 9]] {
        lappend res [dosimul $perm]
    }
    return [lindex [lsort -decreasing -integer $res ] 0]
}