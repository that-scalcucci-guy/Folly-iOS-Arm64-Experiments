The following are files and projects from attempting to cross compile Folly for use on iOS. (I'm not a C++ guy, so I'm sure you'll cringe more than once looking through this).

There is a FollyPhoneTests project that would ideally consume Folly and all of it's dependencies and call them in Objective-C++ code wrappers. 

Inside the project directory are two compressed XCFrameworks that need to be unpacked, 'boost' and 'folly'.

Attempt #1: Heavily Edit Cmake Details

The 'folly' folder is a copy of the source from https://github.com/facebook/folly, and is heavily edited to remove any non-arm64 specific cmake details and manually setting certain defines.

There are compressed 'include' and 'lib' directories that include headers and static libraries specifically compiled for iOS arm64 using the included ios.toolchain.cmake file. Those need to be unpacked.

```cmake -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=OS64```

Attempt #2: Parse & Transmog Mach-O from M1

MacOSToiOS is a utility that parses the mach-o files built for arm64 M1 folly (via Homebrew) and replaces the build-version command to trick LL into accepting them on iOS arm64.

This is a fool's errand, as there are so many platform specific details in Folly. The transmog works for simple libraries on M1, not so much for Folly. 

Attempt #3: Compile from source in Xcode as a static library. 

I won't even go into details on this one. Suffice to say it was not successfuly.
