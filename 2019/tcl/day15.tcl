lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package forget util
package require util
package forget intcode
catch {rename IntCode {}}
package require cintcode

set program [split [read-input day15] ,]
# puts $program


package require Tk
wm geometry . 900x900
canvas .c
pack .c -fill both -expand 1

proc discover {bots worldVar} {
	if {[llength $bots] == 0} return
	upvar $worldVar world
	set nextgen {}
	foreach {bot loc} $bots {
		# puts "$bot @ $loc"
	lassign [split $loc ,] x y
	# nloc
	set neighbours [list $x,[expr {$y-1}] 1]
	# sloc
	lappend neighbours $x,[expr {$y+1}] 2
	# wloc
	lappend neighbours [expr {$x-1}],$y 3
	# eloc
	lappend neighbours [expr {$x+1}],$y 4
	# puts $neighbours
	# parray world
	foreach {loc input} $neighbours {
		# puts _________$nextgen
		if {[info exists world($loc)]} {
			# puts done
			continue
		}
		# puts "dicovering $loc"
		set newbot [$bot clone]

		$newbot input $input
		$newbot clearoutputs
		$newbot run
		set out [lindex [$newbot outputs] end]
		# puts "$loc out->$out"
		lassign [split $loc ,]  x y
		set cx [expr {$x*10 + 300}]
		set cy [expr {$y*10 + 300}]
		switch $out {
			0 { 
				puts wall
				square .c $cx $cy 10 red wall
					update
				set world($loc) X
				rename $newbot {}
			}
			1 {
				set world($loc) .
				square .c $cx $cy 10 white path
					update
				lappend nextgen $newbot $loc
			   }
			2 {
				set world($loc) @
					update
				square .c $cx $cy 10 blue oxy
				lappend nextgen $newbot $loc
			}
		}
	}
	rename $bot {}
	}

	puts xxx[llength $nextgen]
	puts [llength [array names world]]


	tailcall discover $nextgen world
}

proc part1 {} {
	unset -nocomplain world
	set world(0,0) .
	square .c 300 300 10 green start
	set bot [CintCode $::program]
	discover [list $bot 0,0] world
	
}



if {$::argv0 eq [info script]} {
	part1
	puts [info commands cintcode::*]
}