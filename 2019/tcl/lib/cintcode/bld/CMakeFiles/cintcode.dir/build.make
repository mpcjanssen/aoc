# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld

# Include any dependencies generated for this target.
include CMakeFiles/cintcode.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/cintcode.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/cintcode.dir/flags.make

CMakeFiles/cintcode.dir/library.c.o: CMakeFiles/cintcode.dir/flags.make
CMakeFiles/cintcode.dir/library.c.o: ../library.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/cintcode.dir/library.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/cintcode.dir/library.c.o   -c /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/library.c

CMakeFiles/cintcode.dir/library.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/cintcode.dir/library.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/library.c > CMakeFiles/cintcode.dir/library.c.i

CMakeFiles/cintcode.dir/library.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/cintcode.dir/library.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/library.c -o CMakeFiles/cintcode.dir/library.c.s

# Object files for target cintcode
cintcode_OBJECTS = \
"CMakeFiles/cintcode.dir/library.c.o"

# External object files for target cintcode
cintcode_EXTERNAL_OBJECTS =

libcintcode.so: CMakeFiles/cintcode.dir/library.c.o
libcintcode.so: CMakeFiles/cintcode.dir/build.make
libcintcode.so: CMakeFiles/cintcode.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library libcintcode.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/cintcode.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/cintcode.dir/build: libcintcode.so

.PHONY : CMakeFiles/cintcode.dir/build

CMakeFiles/cintcode.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/cintcode.dir/cmake_clean.cmake
.PHONY : CMakeFiles/cintcode.dir/clean

CMakeFiles/cintcode.dir/depend:
	cd /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld /home/mpcjanssen/Sync/Notebooks/aoc/2019/tcl/lib/cintcode/bld/CMakeFiles/cintcode.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/cintcode.dir/depend
