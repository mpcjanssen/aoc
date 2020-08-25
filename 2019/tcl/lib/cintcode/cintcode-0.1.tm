set dir [file dirname [info script]]
switch -exact $tcl_platform(os) {
   windows {load [file join $dir cmake-build-debug libcintcode.dll]}
   Linux {load [file join $dir bld libcintcode.so ]}
   Darwin {load [file normalize [file join $dir bld libcintcode.dylib]]}
   default {error "No binary"}
}
