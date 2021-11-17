
macro(ez_is_project_top_level EZ_RESULT)
	get_directory_property(EZ_HAS_PARENT PARENT_DIRECTORY)
	if(EZ_HAS_PARENT)
		set(${EZ_RESULT} TRUE)
	else()
		set(${EZ_RESULT} FALSE)
	endif()
	unset(EZ_HAS_PARENT)
endmacro()

