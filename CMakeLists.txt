# Oldest version of cmake, Ubuntu long term support
cmake_minimum_required(VERSION 3.16)

project(EZ_CMAKE
	VERSION 0.6.1
	DESCRIPTION "CMake utilities for installing and uninstalling packages"
	HOMEPAGE_URL "https://github.com/errata-c/ez-cmake"
)

# This cmakelists file is included in the repo so that FetchContent will automatically add_subdirectory
# Then we just include install_package.cmake to make the function available
include(install_package.cmake)
include(add_uninstall_target.cmake)