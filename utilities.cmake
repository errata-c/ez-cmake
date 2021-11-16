
macro(ez_is_project_top_level EZ_RESULT)
	get_directory_property(EZ_HAS_PARENT PARENT_DIRECTORY)
	set(${EZ_RESULT} ${EZ_HAS_PARENT} PARENT_SCOPE)
	unset(EZ_HAS_PARENT)
endmacro()

