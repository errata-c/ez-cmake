# Sets the result variable to TRUE if the project is top level, false otherwise.
macro(ez_is_project_top_level EZ_RESULT)
	get_directory_property(EZ_HAS_PARENT PARENT_DIRECTORY)
	if(EZ_HAS_PARENT)
		set(${EZ_RESULT} FALSE)
	else()
		set(${EZ_RESULT} TRUE)
	endif()
	unset(EZ_HAS_PARENT)
endmacro()

