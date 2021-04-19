# Allows creating a custom target for running a cmake script

function(add_script_target TAR_NAME )
	if(TARGET "${TAR_NAME}")
		message(FATAL_ERROR "A target with the name '${TAR_NAME}' already exists!")
	endif()

	if("${TAR_NAME}" STREQUAL "")
		message(FATAL_ERROR "You must input a valid target name!")
	endif()

	set(PARSE_OPTION
		"ALL"
	)
	set(PARSE_SINGLE_VALUE
		"WORKING_DIRECTORY"
	)
	set(PARSE_MULTI_VALUE
		"DEPENDS"
		"BYPRODUCTS"
		"SCRIPTS"
	)

	cmake_parse_arguments(PARSE_ARGV 1
		TAR
		"${PARSE_OPTION}"
		"${PARSE_SINGLE_VALUE}"
		"${PARSE_MULTI_VALUE}"
	)

	if(NOT DEFINED TAR_SCRIPTS)
		message(FATAL_ERROR "You must have at least one script file for a script target")
	endif()

	list(LENGTH TAR_SCRIPTS NUM_SCRIPTS)

	if("${NUM_SCRIPTS}" EQUAL "0")
		message(FATAL_ERROR "You must have at least one script file for a script target")
	endif()

	set(FORWARD "${TAR_NAME}")
	if(DEFINED TAR_ALL)
		list(APPEND FORWARD ALL)
	endif()

	foreach(SCRIPT IN ${TAR_SCRIPTS})
		if(NOT IS_ABSOLUTE "${SCRIPT}")
			set(SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/${SCRIPT}")
		endif()

		if(NOT EXISTS "${SCRIPT}")
			message(FATAL_ERROR "Script file at '${SCRIPT}' does not exist!")
		endif()

		list(APPEND FORWARD "COMMAND" "${CMAKE_COMMAND}" "-P" "${SCRIPT}")
	endforeach()

	if(DEFINED TAR_DEPENDS)
		list(APPEND FORWARD "DEPENDS" ${TAR_DEPENDS})
	endif()

	if(DEFINED TAR_BYPRODUCTS)
		list(APPEND FORWARD "BYPRODUCTS" ${TAR_BYPRODUCTS})
	endif()

	if(DEFINED TAR_WORKING_DIRECTORY)
		list(APPEND FORWARD "WORKING_DIRECTORY" ${TAR_WORKING_DIRECTORY})
	endif()

	add_custom_target(${TAR_NAME} ${FORWARD})
endfunction()