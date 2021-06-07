
set(ADD_UNINSTALL_TARGET_FUNCTION_DIR "${CMAKE_CURRENT_LIST_DIR}")

# Create a custom target for uninstalling anything relating
function(add_uninstall_target UNINSTALL_NAME)
	configure_file(
		"${ADD_UNINSTALL_TARGET_FUNCTION_DIR}/uninstall_script.cmake.in"
		"${PROJECT_BINARY_DIR}/uninstall_script.cmake"
		@ONLY
	)
	
	add_custom_target("${UNINSTALL_NAME}"
		COMMAND ${CMAKE_COMMAND} -P "${PROJECT_BINARY_DIR}/uninstall_script.cmake"
		COMMENT "Running uninstall target '${UNINSTALL_NAME}'"
		VERBATIM
	)
endfunction()