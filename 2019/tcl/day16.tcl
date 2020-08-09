lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package forget util
package require util


proc pattern {n idx} {
	return [lindex {0 1 0 -1} [expr {($idx + 1) / $n % 4}]]
	
}

set data [read-input day16]

proc phase {digits} {
	set result {}
	for {set n 1} {$n <= [llength $digits]} {incr n} {
		set sum 0
		set idx 0
	#	puts -nonewline "$n:\t "
		foreach d $digits {
			set pat [pattern $n $idx]
	#		puts -nonewline "$d*$pat\t"
			incr sum [expr {$d * $pat}]
			incr idx
		}
		set res [expr {abs($sum) % 10}]
	#	puts $sum->$res
		lappend result $res
	}
	return $result
}

proc part1 {} {
     set digits [split $::data {}]
     puts [time {set digits [phase $digits]} 100]
     return [join [lrange $digits 0 7] {}]
}

proc ex1 {} {
     set digits [split 12345678 {}]
     time {set digits [phase $digits]} 4
     return [join [lrange $digits 0 7] {}]
}

if {$::argv0 eq [info script]} {
	puts ex1:[ex1]
	puts part1:[part1]

}