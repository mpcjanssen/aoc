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
	set m [CintCode $::program]
	$m setmem 0 2
	set score 0
	while {[$m state] ne "stopped"} {
		$m run
		# puts [$m state]
		set outputs [$m outputs]
		set paddle {}
		foreach {x y t} $outputs {
			if {$t == 4 && $x != -1} {
				set ballx $x
				set bally $y
			}
			if {$t == 3 && $x != -1} {
				set paddlex  $x 
				set paddley $y
			}
			if {$x == -1} {
				set score $t
			}
		}
		if {$ballx > $paddlex} {
			$m input 1
		} elseif {$ballx == $paddlex} {
			$m input 0
		} else {
			$m input -1
		}

		# puts "Ball $ballx , $bally"
		# puts "Paddel $paddlex, $paddley"
		$m clearoutputs
		# gets stdin
	}
	return $score
}