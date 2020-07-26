set dir [file dirname [info script]]
switch -exact $tcl_platform(platform) {
   windows {load [file join $dir cmake-build-debug libcintcode.dll]}
   unix {load [file join $dir bld libcintcode.so ]}
   default {error "No binary"}
}
