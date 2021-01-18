
include(CMakeFindDependencyMacro)

####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was ConfigTemplate.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)

####################################################################################

#Convenience variables for pre/post config files to access.
set(PACK_NAME ez-cmake)
set(PACK_VERSION 0.2.0)
set(PACK_ROOT ${PACKAGE_PREFIX_DIR})
set(PACK_CONFIG_DIR ${PACKAGE_PREFIX_DIR}/share/ez-cmake)
message("-- Found ${PACK_NAME}: ${PACK_ROOT} (found version ${PACK_VERSION})")

set(ez-cmake_VERSION ${PACK_VERSION} CACHE STRING "Version string for ${PACK_NAME}" FORCE)
set(ez-cmake_PREFIX_DIR ${PACK_ROOT} CACHE STRING "Root directory for the ${PACK_NAME} package" FORCE)
set(ez-cmake_ROOT_DIR ${PACK_ROOT} CACHE STRING "Root directory for the ${PACK_NAME} package" FORCE)
set(ez-cmake_CONFIG_DIR ${PACK_CONFIG_DIR} CACHE STRING "Directory of the configuration files for the ${PACK_NAME} package" FORCE)
mark_as_advanced(ez-cmake_VERSION ez-cmake_PREFIX_DIR ez-cmake_ROOT_DIR ez-cmake_CONFIG_DIR)

include("${PACK_CONFIG_DIR}/install-package.cmake")
include("${PACK_CONFIG_DIR}/compile-options.cmake")

unset(PACK_NAME)
unset(PACK_VERSION)
unset(PACK_ROOT)
unset(PACK_CONFIG_DIR)

set(ez-cmake_FOUND TRUE)
