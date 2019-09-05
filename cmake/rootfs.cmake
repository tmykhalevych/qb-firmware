include_guard(GLOBAL)

include(cmake/board.cmake)

set(ROOTFS_CROSS_COMPILE $ENV{QB_BUILD_TOOL_NAME}-)

set(BUSYBOX_SRC_DIR ${PROJECT_SOURCE_DIR}/os/busybox)
set(BUSYBOX_BUILD_DIR ${CMAKE_BINARY_DIR}/busybox)
set(BUSYBOX_CROSSCOMPILE_PARAMS ARCH=${ARCH} CROSS_COMPILE=${ROOTFS_CROSS_COMPILE} O=${BUSYBOX_BUILD_DIR})
set(BUSYBOX_MAKE_PARAMS) # Currently there is nothing here
set(BUSYBOX_BUILD_TARGETS) # Currently there is nothing here
set(BUSYBOX_INSTALL_TARGETS install)
set(BUSYBOX_INSTALL_FLAFS CONFIG_PREFIX=${FIRMWARE_ROOTFS_ROOT})

set(SYSTEM_INIT_FILE ${PROJECT_SOURCE_DIR}/os/rcS)

# Busybox commands

add_custom_command( OUTPUT bb-configure
    COMMAND sh ${PROJECT_SOURCE_DIR}/setup.env
    COMMAND mkdir -p ${BUSYBOX_BUILD_DIR}
    COMMAND make ${BUSYBOX_MAKE_PARAMS} distclean
    COMMAND make ${BUSYBOX_MAKE_PARAMS} ${BUSYBOX_CROSSCOMPILE_PARAMS} defconfig
    WORKING_DIRECTORY ${BUSYBOX_SRC_DIR}
)

add_custom_command( OUTPUT bb-build
    COMMAND sh ${PROJECT_SOURCE_DIR}/setup.env
    COMMAND make ${BUSYBOX_MAKE_PARAMS} clean
    COMMAND make ${BUSYBOX_MAKE_PARAMS} ${BUSYBOX_CROSSCOMPILE_PARAMS} ${BUSYBOX_BUILD_TARGETS}
    COMMAND make ${BUSYBOX_MAKE_PARAMS} ${BUSYBOX_CROSSCOMPILE_PARAMS} ${BUSYBOX_INSTALL_TARGETS} ${BUSYBOX_INSTALL_FLAFS}
    WORKING_DIRECTORY ${BUSYBOX_SRC_DIR}
)

add_custom_command( OUTPUT bb-clean
    COMMAND make ${BUSYBOX_MAKE_PARAMS} distclean
    COMMAND rm -rf ${BUSYBOX_BUILD_DIR}
    WORKING_DIRECTORY ${BUSYBOX_SRC_DIR}
)

# TODO: GLIBC targets

# Rootfs targets

add_custom_target( fs-configure
    DEPENDS 
        bb-configure
)

add_custom_target( fs-build
    COMMAND mkdir -p proc sys dev etc/init.d usr/lib
    COMMAND cp -u ${SYSTEM_INIT_FILE}  etc/init.d/
    COMMAND chmod +x etc/init.d/rcS
    WORKING_DIRECTORY ${FIRMWARE_ROOTFS_ROOT}

    DEPENDS 
        bb-build
)

add_custom_target( fs-clean
    COMMAND rm -rf proc sys dev etc/init.d usr/lib
    WORKING_DIRECTORY ${FIRMWARE_ROOTFS_ROOT}

    DEPENDS 
        bb-clean
)
