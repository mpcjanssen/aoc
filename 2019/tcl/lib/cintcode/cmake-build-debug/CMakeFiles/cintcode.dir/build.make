# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = C:\Users\Mark\scoop\persist\jetbrains-toolbox\apps\CLion\ch-0\201.7846.88\bin\cmake\win\bin\cmake.exe

# The command to remove a file.
RM = C:\Users\Mark\scoop\persist\jetbrains-toolbox\apps\CLion\ch-0\201.7846.88\bin\cmake\win\bin\cmake.exe -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/cintcode.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/cintcode.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/cintcode.dir/flags.make

CMakeFiles/cintcode.dir/library.c.obj: CMakeFiles/cintcode.dir/flags.make
CMakeFiles/cintcode.dir/library.c.obj: ../library.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/cintcode.dir/library.c.obj"
	C:\Users\Mark\scoop\apps\msys2\2020-06-29\mingw64\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles\cintcode.dir\library.c.obj   -c C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\library.c

CMakeFiles/cintcode.dir/library.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/cintcode.dir/library.c.i"
	C:\Users\Mark\scoop\apps\msys2\2020-06-29\mingw64\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\library.c > CMakeFiles\cintcode.dir\library.c.i

CMakeFiles/cintcode.dir/library.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/cintcode.dir/library.c.s"
	C:\Users\Mark\scoop\apps\msys2\2020-06-29\mingw64\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\library.c -o CMakeFiles\cintcode.dir\library.c.s

# Object files for target cintcode
cintcode_OBJECTS = \
"CMakeFiles/cintcode.dir/library.c.obj"

# External object files for target cintcode
cintcode_EXTERNAL_OBJECTS =

libcintcode.dll: CMakeFiles/cintcode.dir/library.c.obj
libcintcode.dll: CMakeFiles/cintcode.dir/build.make
libcintcode.dll: CMakeFiles/cintcode.dir/linklibs.rsp
libcintcode.dll: CMakeFiles/cintcode.dir/objects1.rsp
libcintcode.dll: CMakeFiles/cintcode.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library libcintcode.dll"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\cintcode.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/cintcode.dir/build: libcintcode.dll

.PHONY : CMakeFiles/cintcode.dir/build

CMakeFiles/cintcode.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\cintcode.dir\cmake_clean.cmake
.PHONY : CMakeFiles/cintcode.dir/clean

CMakeFiles/cintcode.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\cmake-build-debug C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\cmake-build-debug C:\Users\Mark\Src\aoc\2019\tcl\lib\cintcode\cmake-build-debug\CMakeFiles\cintcode.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/cintcode.dir/depend

