include_guard(GLOBAL)

include(cmake/board.cmake)
include(cmake/linux.cmake)

# Busybox build commands
set(BUSYBOX_CROSS_COMPILE $ENV{QB_BUILD_TOOL_NAME}-)
set(BUSYBOX_SRC_DIR ${PROJECT_SOURCE_DIR}/os/busybox)
set(BUSYBOX_BUILD_DIR ${CMAKE_BINARY_DIR}/busybox)
set(BUSYBOX_CROSSCOMPILE_PARAMS ARCH=${ARCH} CROSS_COMPILE=${ROOTFS_CROSS_COMPILE} O=${BUSYBOX_BUILD_DIR})
set(BUSYBOX_MAKE_PARAMS) # Currently there is nothing here
set(BUSYBOX_INSTALL_FLAFS CONFIG_PREFIX=${FIRMWARE_ROOTFS_ROOT})

add_custom_command( OUTPUT busybox-build-cmd
    COMMAND sh ${PROJECT_SOURCE_DIR}/setup.env
    COMMAND mkdir -p ${BUSYBOX_BUILD_DIR}
    COMMAND make ${BUSYBOX_MAKE_PARAMS} distclean
    COMMAND make ${BUSYBOX_MAKE_PARAMS} ${BUSYBOX_CROSSCOMPILE_PARAMS} defconfig
    COMMAND make ${BUSYBOX_MAKE_PARAMS} ${BUSYBOX_CROSSCOMPILE_PARAMS}
    COMMAND make ${BUSYBOX_MAKE_PARAMS} ${BUSYBOX_CROSSCOMPILE_PARAMS} install ${BUSYBOX_INSTALL_FLAFS}
    WORKING_DIRECTORY ${BUSYBOX_SRC_DIR}
)

add_custom_command( OUTPUT busybox-clean-cmd
    COMMAND make ${BUSYBOX_MAKE_PARAMS} distclean
    COMMAND rm -rf ${BUSYBOX_BUILD_DIR}
    COMMAND rm -rf ${FIRMWARE_ROOTFS_ROOT}/bin ${FIRMWARE_ROOTFS_ROOT}/sbin ${FIRMWARE_ROOTFS_ROOT}/usr ${FIRMWARE_ROOTFS_ROOT}/linuxrc
    WORKING_DIRECTORY ${BUSYBOX_SRC_DIR}
)

# GLIBC build commands
set(GLIBC_SRC_DIR ${PROJECT_SOURCE_DIR}/os/glibc)
set(GLIBC_BUILD_DIR ${CMAKE_BINARY_DIR}/glibc)
set(GLIBC_INSTALL_FLAFS install_root=${FIRMWARE_ROOTFS_ROOT}/lib)
set(GLIBC_MAKE_PARAMS
    CC=${CMAKE_C_COMPILER}
    LD=${CROSS_C_LINKER}
    AS=${CROSS_ASM_COMPILER}
)
set(GLIBC_CONFIGURE_PARAMS 
    --build=$ENV{HOST_ARCH}
    --target=${ARCH}
    --prefix=${FIRMWARE_ROOTFS_ROOT}/lib
    --enable-add-ons
)

add_custom_command( OUTPUT glibc-prepare-cmd
    COMMAND rm -rf ${GLIBC_BUILD_DIR}
    COMMAND mkdir ${GLIBC_BUILD_DIR}
)

add_custom_command( OUTPUT glibc-build-cmd
    COMMAND ${GLIBC_SRC_DIR}/configure ${GLIBC_CONFIGURE_PARAMS}
    COMMAND make ${GLIBC_MAKE_PARAMS}
    COMMAND make ${GLIBC_MAKE_PARAMS} install ${GLIBC_INSTALL_FLAFS}
    DEPENDS glibc-prepare-cmd
    WORKING_DIRECTORY ${GLIBC_BUILD_DIR}
)

add_custom_command( OUTPUT glibc-clean-cmd
    COMMAND rm -rf ${GLIBC_BUILD_DIR}
)

# Dropbear (SSH connections) build commands
set(DROPBEAR_CROSS_COMPILE $ENV{QB_BUILD_TOOL_NAME}-)
set(DROPBEAR_SRC_DIR ${PROJECT_SOURCE_DIR}/os/dropbear)
set(DROPBEAR_BUILD_DIR ${CMAKE_BINARY_DIR}/dropbear)
set(DROPBEAR_CROSSCOMPILE_PARAMS)
set(DROPBEAR_MAKE_PARAMS) # Currently there is nothing here
set(DROPBEAR_INSTALL_FLAFS DESTDIR=${FIRMWARE_ROOTFS_ROOT})

add_custom_command( OUTPUT dropbear-prepare-cmd
    # TODO
)

add_custom_command( OUTPUT dropbear-build-cmd
    # TODO
    DEPENDS dropbear-prepare-cmd
)

add_custom_command( OUTPUT dropbear-clean-cmd
    # TODO
)

# Rootfs general commands
set(INIT_SRC_DIR ${PROJECT_SOURCE_DIR}/os/init)
set(ROOTFS_AUXILARY_FOLDERS etc proc sys dev dev/pts tmp root mnt boot run)

add_custom_target( fs-build
    # TODO: Copy linux init scripts
    COMMAND mkdir -p ${ROOTFS_AUXILARY_FOLDERS}
    COMMAND sh ${INIT_SRC_DIR}/attach-hostname.sh
    WORKING_DIRECTORY ${FIRMWARE_ROOTFS_ROOT}

    DEPENDS 
        busybox-build-cmd
        #dropbear-build-cmd
        #glibc-build-cmd
)

add_custom_target( fs-clean
    # TODO: Delete linux init scripts
    COMMAND rm -rf ${ROOTFS_AUXILARY_FOLDERS}
    WORKING_DIRECTORY ${FIRMWARE_ROOTFS_ROOT}

    DEPENDS 
        busybox-clean-cmd
        #dropbear-clean-cmd
        #glibc-clean-cmd
)
