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
include folly/CMakeFiles/follybenchmark.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include folly/CMakeFiles/follybenchmark.dir/compiler_depend.make

# Include the progress variables for this target.
include folly/CMakeFiles/follybenchmark.dir/progress.make

# Include the compile flags for this target's objects.
include folly/CMakeFiles/follybenchmark.dir/flags.make

folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.o: folly/CMakeFiles/follybenchmark.dir/flags.make
folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.o: folly/Benchmark.cpp
folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.o: folly/CMakeFiles/follybenchmark.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/wsbuild/Downloads/folly/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.o"
	cd /Users/wsbuild/Downloads/folly/folly && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.o -MF CMakeFiles/follybenchmark.dir/Benchmark.cpp.o.d -o CMakeFiles/follybenchmark.dir/Benchmark.cpp.o -c /Users/wsbuild/Downloads/folly/folly/Benchmark.cpp

folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/follybenchmark.dir/Benchmark.cpp.i"
	cd /Users/wsbuild/Downloads/folly/folly && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/wsbuild/Downloads/folly/folly/Benchmark.cpp > CMakeFiles/follybenchmark.dir/Benchmark.cpp.i

folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/follybenchmark.dir/Benchmark.cpp.s"
	cd /Users/wsbuild/Downloads/folly/folly && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/wsbuild/Downloads/folly/folly/Benchmark.cpp -o CMakeFiles/follybenchmark.dir/Benchmark.cpp.s

# Object files for target follybenchmark
follybenchmark_OBJECTS = \
"CMakeFiles/follybenchmark.dir/Benchmark.cpp.o"

# External object files for target follybenchmark
follybenchmark_EXTERNAL_OBJECTS =

folly/libfollybenchmark.a: folly/CMakeFiles/follybenchmark.dir/Benchmark.cpp.o
folly/libfollybenchmark.a: folly/CMakeFiles/follybenchmark.dir/build.make
folly/libfollybenchmark.a: folly/CMakeFiles/follybenchmark.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/wsbuild/Downloads/folly/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libfollybenchmark.a"
	cd /Users/wsbuild/Downloads/folly/folly && $(CMAKE_COMMAND) -P CMakeFiles/follybenchmark.dir/cmake_clean_target.cmake
	cd /Users/wsbuild/Downloads/folly/folly && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/follybenchmark.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
folly/CMakeFiles/follybenchmark.dir/build: folly/libfollybenchmark.a
.PHONY : folly/CMakeFiles/follybenchmark.dir/build

folly/CMakeFiles/follybenchmark.dir/clean:
	cd /Users/wsbuild/Downloads/folly/folly && $(CMAKE_COMMAND) -P CMakeFiles/follybenchmark.dir/cmake_clean.cmake
.PHONY : folly/CMakeFiles/follybenchmark.dir/clean

folly/CMakeFiles/follybenchmark.dir/depend:
	cd /Users/wsbuild/Downloads/folly && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/wsbuild/Downloads/folly /Users/wsbuild/Downloads/folly/folly /Users/wsbuild/Downloads/folly /Users/wsbuild/Downloads/folly/folly /Users/wsbuild/Downloads/folly/folly/CMakeFiles/follybenchmark.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : folly/CMakeFiles/follybenchmark.dir/depend

