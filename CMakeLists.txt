cmake_minimum_required(VERSION 3.15)

project(EZ_CMAKE
VERSION 0.5.0)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/ez-cmakeConfigVersion.cmake"
VERSION ${BG_INSTALL_PACKAGE}
COMPATIBILITY SameMajorVersion
)

install(
	FILES 
		"${CMAKE_CURRENT_SOURCE_DIR}/ez-cmake-config.cmake"
		"${CMAKE_CURRENT_BINARY_DIR}/ez-cmakeConfigVersion.cmake"
	DESTINATION "ez-cmake/share/ez-cmake"
)
install(
	DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/cmake/"
	DESTINATION "ez-cmake/share/ez-cmake"
)
