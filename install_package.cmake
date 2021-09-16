include(CMakePackageConfigHelpers)

function(install_package)
	set(PARSE_OPTION
		"ARCH_INDEPENDENT"
		"EXPORT_LINK_INTERFACE_LIBRARIES"
		"EXCLUDE_FROM_ALL"
	)
	set(PARSE_SINGLE_VALUE
		"NAME"
		"NAMESPACE"
		"EXPORT"
		"VERSION"
		"COMPATIBILITY"
		"COMPONENT"
		"DESTINATION"
		"PRECONFIG"
		"POSTCONFIG"
	)
	set(PARSE_MULTI_VALUE
		"CONFIGURATIONS"
		"PERMISSIONS"
	)

	cmake_parse_arguments(PARSE_ARGV 0
		PACK
		"${PARSE_OPTION}"
		"${PARSE_SINGLE_VALUE}"
		"${PARSE_MULTI_VALUE}"
	)

	if(NOT DEFINED PACK_NAME)
		message(FATAL_ERROR "install_package: No NAME passed into install_package function\n"
		"install_package: Expected form for argument is \'NAME <package-name>\'")
	endif()

	if(NOT DEFINED PACK_DESTINATION)
		message(FATAL_ERROR "install_package: No install destination passed into install_package function\n"
		"install_package: Expected form for the argument is \'DESTINATION <install location>\'")
	endif()

	if("${PACK_DESTINATION}" STREQUAL "DEFAULT")
		set(PACK_DESTINATION "share/${PACK_NAME}")
	elseif(IS_ABSOLUTE "${PACK_DESTINATION}")
		message(WARNING "The DESTINATION for the package ${PACK_NAME} is an absolute path, install_package expects a relative path.\n"
		"This can cause issues if the absolute path of ${PACK_NAME} is not actually along the same directory branch as CMAKE_INSTALL_PREFIX.")
		
		file(RELATIVE_PATH PACK_DESTINATION "${CMAKE_INSTALL_PREFIX}" "${PACK_DESTINATION}")
	endif()
	
	if(NOT DEFINED PACK_EXPORT)
		message(FATAL_ERROR "install_package: No EXPORT passed into install_package function\n"
		"install_package: Expected form for argument is \'EXPORT <exported-targets>\'")
	endif()

	if(NOT DEFINED PACK_VERSION)
		message(FATAL_ERROR "install_package: No VERSION passed into install_package function.\n"
		"install_package: Expected form for argument is \'VERSION <major.minor.patch>\'")
	elseif(NOT "${PACK_VERSION}" MATCHES "[0-9]+(\.[0-9]+(\.[0-9])?)?")
		message(FATAL_ERROR "install_package: Invalid version number passed to install_package function")
	endif()

	if(NOT DEFINED PACK_COMPATIBILITY)
		message(FATAL_ERROR "install_package: No COMPATIBILITY passed into install_package function.\n"
		"install_package: Expected form for argument is \'COMPATIBILITY <AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion>\'")
	endif()

	if(NOT "${PACK_COMPATIBILITY}" MATCHES "(AnyNewerVersion)|(SameMajorVersion)|(SameMinorVersion)|(ExactVersion)")
		message(FATAL_ERROR "install_package: Invalid value passed into COMPATIBILITY argument of install_package.\n"
		"install_package: Expected form for argument is \'COMPATIBILITY <AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion>\'")
	endif()

	if(DEFINED PACK_NAMESPACE)
		set(PACK_NAMESPACE "NAMESPACE" "${PACK_NAMESPACE}")
	endif()

	if(DEFINED PACK_PERMISSIONS)
		set(PACK_PERMISSIONS "PERMISSIONS" "${PACK_PERMISSIONS}")
	endif()

	if(PACK_EXPORT_LINK_INTERFACE_LIBRARIES)
		set(PACK_EXPORT_LINK_INTERFACE_LIBRARIES "EXPORT_LINK_INTERFACE_LIBRARIES")
		message(DEPRECATION "The EXPORT_LINK_INTERFACE_LIBRARIES option should not be used if possible")
	else()
		set(PACK_EXPORT_LINK_INTERFACE_LIBRARIES)
	endif()
	
	if(PACK_ARCH_INDEPENDENT)
		set(PACK_ARCH_INDEPENDENT "ARCH_INDEPENDENT")
	else()
		set(PACK_ARCH_INDEPENDENT)
	endif()

	if(DEFINED PACK_COMPONENT)
		set(PACK_COMPONENT "COMPONENT" "${PACK_COMPONENT}")
	endif()

	if(DEFINED PACK_CONFIGURATIONS)
		set(PACK_CONFIGURATIONS "CONFIGURATIONS" "${PACK_CONFIGURATIONS}")
	endif()

	if(PACK_EXCLUDE_FROM_ALL)
		set(PACK_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
	else()
		set(PACK_EXCLUDE_FROM_ALL)
	endif()

	# Install the targets from the build tree to the install destination.
	install(EXPORT "${PACK_EXPORT}" DESTINATION "${PACK_DESTINATION}"
		FILE "${PACK_NAME}-targets.cmake"
		${PACK_NAMESPACE}
		${PACK_PERMISSIONS}
		${PACK_CONFIGURATIONS}
		${PACK_EXPORT_LINK_INTERFACE_LIBRARIES}
		${PACK_COMPONENT}
		${PACK_EXCLUDE_FROM_ALL}
	)
	
	foreach(CONFIG IN ITEMS "PACK_PRECONFIG" "PACK_POSTCONFIG")
		if(DEFINED ${CONFIG})
			if(NOT IS_ABSOLUTE ${${CONFIG}})
				set(${CONFIG} ${CMAKE_CURRENT_LIST_DIR}/${${CONFIG}})
			endif()

			get_filename_component(CONFIG_FILENAME ${${CONFIG}} NAME)
			set(CONFIG_FILE ${${CONFIG}})

			if(NOT EXISTS ${${CONFIG}})
				message(FATAL_ERROR "The preconfiguration file \'${CONFIG_FILE}\' does not exist")
			endif()
		
			if(NOT ${CONFIG_FILENAME} MATCHES ".+\.cmake$")
				message(FATAL_ERROR "The file passed into ${CONFIG} is not a valid cmake script file.")
			endif()
		
			set(${CONFIG}_INCLUDE "include(\"\$\{CMAKE_CURRENT_LIST_DIR\}/${CONFIG_FILENAME}\")\n")
			
			install(
				FILES
					${CONFIG_FILE}
				DESTINATION
					"${PACK_DESTINATION}"
			)
		else()
			set(${CONFIG}_INCLUDE "")
		endif()
	endforeach()

	# We create the file in a location we have write access to, as it will be installed AFTER building, not immediately.
	write_basic_package_version_file(
		"${CMAKE_CURRENT_BINARY_DIR}/tmp/${PACK_NAME}-config-version.cmake"
		VERSION ${PACK_VERSION}
		COMPATIBILITY ${PACK_COMPATIBILITY}
		${PACK_ARCH_INDEPENDENT}
	)

	# We create the file in a location we have write access to as it will be installed AFTER configuration, not immediately.
	# Additionally, the file is written directly to have less external dependencies.
	file(WRITE
		"${CMAKE_CURRENT_BINARY_DIR}/tmp/ConfigTemplate.cmake.in"
		"include_guard(DIRECTORY)\n"
		"include(CMakeFindDependencyMacro)\n"
		"@PACKAGE_INIT@\n"
		"\n"
		"set(@PACK_NAME@_VERSION @PACK_VERSION@)\n"
		"set(@PACK_NAME@_PREFIX_DIR \$\{PACKAGE_PREFIX_DIR\})\n"
		"set(@PACK_NAME@_CONFIG_DIR @PACK_DESTINATION@)\n"
		"\n"
		"if(NOT @PACK_NAME@_FIND_QUIETLY)\n"
		"  message(STATUS \"Found @PACK_NAME@ (version @PACK_VERSION@): \$\{PACKAGE_PREFIX_DIR\}\")\n"
		"endif()\n"
		"\n"
		"mark_as_advanced(@PACK_NAME@_VERSION @PACK_NAME@_PREFIX_DIR @PACK_NAME@_CONFIG_DIR)\n\n"
		"${PACK_PRECONFIG_INCLUDE}\n"
		"include(\"\$\{CMAKE_CURRENT_LIST_DIR\}/@PACK_NAME@-targets.cmake\")\n"
		"${PACK_POSTCONFIG_INCLUDE}\n"
		"\n"
		"check_required_components(@PACK_NAME@)\n"
	)

	# The INSTALL_DESTINATION value is not specifying an install command, just where we expect to install it.
	# As such we have to actuall specify an install command after this.
	configure_package_config_file(
		"${CMAKE_CURRENT_BINARY_DIR}/tmp/ConfigTemplate.cmake.in"
		"${CMAKE_CURRENT_BINARY_DIR}/tmp/${PACK_NAME}-config.cmake"
		INSTALL_DESTINATION "${PACK_DESTINATION}" # Relative destination
	)
	
	# Install the generated config files.
	install(
		FILES
			"${CMAKE_CURRENT_BINARY_DIR}/tmp/${PACK_NAME}-config-version.cmake"
			"${CMAKE_CURRENT_BINARY_DIR}/tmp/${PACK_NAME}-config.cmake"
		DESTINATION "${PACK_DESTINATION}"

		${PACK_PERMISSIONS}
		${PACK_CONFIGURATIONS}
		${PACK_COMPONENT}
		${PACK_EXCLUDE_FROM_ALL}
	)
endfunction()