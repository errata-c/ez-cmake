# ez-cmake

This package provides a function to make installing cmake targets much easier.

## Details

Packages generated with this function can be taken from the install directory and moved to somewhere else, and still work.

Multiple configuratiions can be installed into the same directory, so long as its possible for each configuration to tell which files belong to it. One way to do this would be to put each configuration into its own directory using generator expressions like this:
```cmake
install(TARGETS target
	EXPORT target-export
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}/$<CONFIG>"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/$<CONFIG>"
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/$<CONFIG>"
)
```

When refering to a file that will be installed alongside the package, you must wrap the path in generator expressions to make sure it works correctly in both build and install.
For instance:
```cmake
target_include_directories(target PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:include>
)
```

Having different interface properties per config, put in by if() statements will disallow multiple configurations being installed to one directory. This can be mitigated by using generator expressions instead of configuration time if statements.
For instance:
```
target_compile_definitions(target PUBLIC 
	$<IF:<CONFIG:Debug>,DEBUG,NDEBUG>
)
```

In general, _ALL_ properties on targets should be inside generator expressions when you want them to apply to specific configurations only.

The DESTINATION argument should be the path to the configuration files _relative_ to the package root directory.

The ARCH_INDEPENDENT option should be used for header only libraries and INTERFACE libraries.

The EXPORT_LINK_INTERFACE_LIBRARIES options should not be used if possible.

COMPATIBILITY should be one of these values: `<AnyNewerVersion | SameMajorVersion | SameMinorVersion | ExactVersion>`

PRECONFIG and POSTCONFIG are used to specify cmake files to be included before the package targets are initialized, and after the package targets are initialized respectively.
Both PRECONFIG and POSTCONFIG must reference an actual file, and it must have the .cmake extention. 

Generally speaking, PRECONFIG is used for finding target dependencies needed by your libraries, and POSTCONFIG is used for adding onto or otherwise modifying the targets after they've been initialized.

The CONFIGURATIONS multi value argument is used to whitelist certain configurations.
If, for instance, you had only specifically supported Release and Debug configurations, all other configurations would cause an error when attempting to find the package.
In most cases this will not be necessary, as long as you package the main list of basic configurations: Debug, Release, RelWithDebInfo, MinSizeRel

The NAMESPACE argument can be used to specify a prefix to be added to all targets in the package.

An example usage for the install_package function:
```cmake
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
	TYPE INCLUDE
	FILES_MATCHING
	PATTERN "*.h" PATTERN "*.hpp"
)

install(TARGETS target
	EXPORT target-export
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}/$<CONFIG>"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/$<CONFIG>"
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/$<CONFIG>"
)

install_package(
	NAME "package_name"
	NAMESPACE "package_namespace"
	DESTINATION "${RELATIVE_CONFIG_DIR}"
	EXPORT "target-export"
	VERSION "${PROJECT_VERSION}"
	COMPATIBILITY "SameMajorVersion"
	PRECONFIG "cmake/preconfig.cmake"
	ARCH_INDEPENDENT
)
```