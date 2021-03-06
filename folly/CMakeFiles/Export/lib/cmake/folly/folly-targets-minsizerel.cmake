#----------------------------------------------------------------
# Generated CMake target import file for configuration "MinSizeRel".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Folly::folly" for configuration "MinSizeRel"
set_property(TARGET Folly::folly APPEND PROPERTY IMPORTED_CONFIGURATIONS MINSIZEREL)
set_target_properties(Folly::folly PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_MINSIZEREL "CXX"
  IMPORTED_LOCATION_MINSIZEREL "${_IMPORT_PREFIX}/lib/libfolly.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Folly::folly )
list(APPEND _IMPORT_CHECK_FILES_FOR_Folly::folly "${_IMPORT_PREFIX}/lib/libfolly.a" )

# Import target "Folly::folly_test_util" for configuration "MinSizeRel"
set_property(TARGET Folly::folly_test_util APPEND PROPERTY IMPORTED_CONFIGURATIONS MINSIZEREL)
set_target_properties(Folly::folly_test_util PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_MINSIZEREL "CXX"
  IMPORTED_LOCATION_MINSIZEREL "${_IMPORT_PREFIX}/lib/libfolly_test_util.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Folly::folly_test_util )
list(APPEND _IMPORT_CHECK_FILES_FOR_Folly::folly_test_util "${_IMPORT_PREFIX}/lib/libfolly_test_util.a" )

# Import target "Folly::follybenchmark" for configuration "MinSizeRel"
set_property(TARGET Folly::follybenchmark APPEND PROPERTY IMPORTED_CONFIGURATIONS MINSIZEREL)
set_target_properties(Folly::follybenchmark PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_MINSIZEREL "CXX"
  IMPORTED_LOCATION_MINSIZEREL "${_IMPORT_PREFIX}/lib/libfollybenchmark.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Folly::follybenchmark )
list(APPEND _IMPORT_CHECK_FILES_FOR_Folly::follybenchmark "${_IMPORT_PREFIX}/lib/libfollybenchmark.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
