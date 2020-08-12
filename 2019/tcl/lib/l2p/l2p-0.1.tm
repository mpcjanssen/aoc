set dir [file dirname [info script]]
switch -exact $tcl_platform(platform) {
   windows {load [file join $dir cmake-build-debug libl2p.dll] L2p}
   unix {load [file join $dir bld libl2p.so ]}
   default {error "No binary"}
}

