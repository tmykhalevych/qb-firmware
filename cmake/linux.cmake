include(cmake/board.cmake)

set(LINUX_DIR ${PROJECT_SOURCE_DIR}/linux)

add_custom_target( os-prepare
    COMMAND sh ${PROJECT_SOURCE_DIR}/setup.env && make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} ${DEFCONFIG}
    WORKING_DIRECTORY ${LINUX_DIR}
)

add_custom_target( os-build
    COMMAND sh ${PROJECT_SOURCE_DIR}/setup.env && make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} zImage modules dtbs
    WORKING_DIRECTORY ${LINUX_DIR}
)

add_custom_target( os-image
    # TODO: Implement
)
