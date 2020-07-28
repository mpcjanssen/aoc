lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package forget util
package require util
package forget intcode
catch {rename IntCode {}}
package require cintcode

set program [split [read-input day13] ,]


proc part1 {} {
	set m [CintCode $::program]
	$m run
	foreach {x y t} [$m outputs] {
		if {$t == 2} {
			incr blocks
		}
	}
	return $blocks
}

proc part2 {} {
    set res {}
    foreach perm [permutations [range 5 9]] {
        lappend res [dosimul $perm]
    }
    return [lindex [lsort -decreasing -integer $res ] 0]
}