# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.20

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

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.20.1/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.20.1/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/wsbuild/Downloads/folly

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/wsbuild/Downloads/folly

# Include any dependencies generated for this target.
include folly/logging/example/CMakeFiles/logging_example.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include folly/logging/example/CMakeFiles/logging_example.dir/compiler_depend.make

# Include the progress variables for this target.
include folly/logging/example/CMakeFiles/logging_example.dir/progress.make

# Include the compile flags for this target's objects.
include folly/logging/example/CMakeFiles/logging_example.dir/flags.make

folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.o: folly/logging/example/CMakeFiles/logging_example.dir/flags.make
folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.o: folly/logging/example/main.cpp
folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.o: folly/logging/example/CMakeFiles/logging_example.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/wsbuild/Downloads/folly/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.o"
	cd /Users/wsbuild/Downloads/folly/folly/logging/example && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.o -MF CMakeFiles/logging_example.dir/main.cpp.o.d -o CMakeFiles/logging_example.dir/main.cpp.o -c /Users/wsbuild/Downloads/folly/folly/logging/example/main.cpp

folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/logging_example.dir/main.cpp.i"
	cd /Users/wsbuild/Downloads/folly/folly/logging/example && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/wsbuild/Downloads/folly/folly/logging/example/main.cpp > CMakeFiles/logging_example.dir/main.cpp.i

folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/logging_example.dir/main.cpp.s"
	cd /Users/wsbuild/Downloads/folly/folly/logging/example && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/wsbuild/Downloads/folly/folly/logging/example/main.cpp -o CMakeFiles/logging_example.dir/main.cpp.s

# Object files for target logging_example
logging_example_OBJECTS = \
"CMakeFiles/logging_example.dir/main.cpp.o"

# External object files for target logging_example
logging_example_EXTERNAL_OBJECTS =

folly/logging/example/logging_example: folly/logging/example/CMakeFiles/logging_example.dir/main.cpp.o
folly/logging/example/logging_example: folly/logging/example/CMakeFiles/logging_example.dir/build.make
folly/logging/example/logging_example: folly/logging/example/liblogging_example_lib.a
folly/logging/example/logging_example: libfolly.a
folly/logging/example/logging_example: /opt/homebrew/lib/libfmt.7.1.3.dylib
folly/logging/example/logging_example: /opt/homebrew/lib/libboost_context-mt.a
folly/logging/example/logging_example: /opt/homebrew/lib/libboost_filesystem-mt.a
folly/logging/example/logging_example: /opt/homebrew/lib/libboost_program_options-mt.a
folly/logging/example/logging_example: /opt/homebrew/lib/libboost_regex-mt.a
folly/logging/example/logging_example: /opt/homebrew/lib/libboost_system-mt.a
folly/logging/example/logging_example: /opt/homebrew/lib/libboost_thread-mt.a
folly/logging/example/logging_example: ~/lib/libdouble-conversion.a
folly/logging/example/logging_example: /opt/homebrew/lib/libevent.dylib
folly/logging/example/logging_example: ~/lib/libcrypto.a
folly/logging/example/logging_example: ~/lib/libssl.a
folly/logging/example/logging_example: folly/logging/example/CMakeFiles/logging_example.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/wsbuild/Downloads/folly/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable logging_example"
	cd /Users/wsbuild/Downloads/folly/folly/logging/example && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/logging_example.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
folly/logging/example/CMakeFiles/logging_example.dir/build: folly/logging/example/logging_example
.PHONY : folly/logging/example/CMakeFiles/logging_example.dir/build

folly/logging/example/CMakeFiles/logging_example.dir/clean:
	cd /Users/wsbuild/Downloads/folly/folly/logging/example && $(CMAKE_COMMAND) -P CMakeFiles/logging_example.dir/cmake_clean.cmake
.PHONY : folly/logging/example/CMakeFiles/logging_example.dir/clean

folly/logging/example/CMakeFiles/logging_example.dir/depend:
	cd /Users/wsbuild/Downloads/folly && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/wsbuild/Downloads/folly /Users/wsbuild/Downloads/folly/folly/logging/example /Users/wsbuild/Downloads/folly /Users/wsbuild/Downloads/folly/folly/logging/example /Users/wsbuild/Downloads/folly/folly/logging/example/CMakeFiles/logging_example.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : folly/logging/example/CMakeFiles/logging_example.dir/depend

