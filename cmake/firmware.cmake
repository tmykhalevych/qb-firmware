include(cmake/linux.cmake)

function( add_fw_module target)
    install(
        TARGETS ${target}
        RUNTIME DESTINATION qb/bin
        LIBRARY DESTINATION qb/lib
    )
endfunction()

function( add_fw_unit unit)
    install(
        FILES ${unit} 
        DESTINATION qb/system
    )
endfunction()

add_custom_target( image
    # TODO: Implement
)
