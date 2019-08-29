include(cmake/board.cmake)

set(BOOT_DIR ${PROJECT_SOURCE_DIR}/boot)
set(BROADCOM_PRECOMPILED ${BOOT_DIR}/broadcom)
set(UBOOT_SRC_DIR ${BOOT_DIR}/u-boot)
set(BOOT_TOOLS_DIR ${BOOT_DIR}/tools)
set(UBOOT_BUILD_DIR ${CMAKE_BINARY_DIR}/u-boot)
set(UBOOT_CROSSCOMPILE_PARAMS CROSS_COMPILE=$ENV{QB_BUILD_TOOL_NAME}- O=${UBOOT_BUILD_DIR})
set(UBOOT_MAKE_PARAMS) # Currently there is nothing here
set(UBOOT_TARGETS u-boot.bin)

add_custom_target( bl-build # bl for bootloader
    COMMAND sh ${PROJECT_SOURCE_DIR}/setup.env
    COMMAND make ${UBOOT_MAKE_PARAMS} distclean # Yes, full clean every time
    COMMAND make ${UBOOT_MAKE_PARAMS} ${UBOOT_CROSSCOMPILE_PARAMS} ${UBOOT_DEFCONFIG}
    COMMAND COMMAND make ${UBOOT_MAKE_PARAMS} ${UBOOT_CROSSCOMPILE_PARAMS} ${UBOOT_TARGETS}
    COMMAND mkdir -p ${FIRMWARE_BOOT_ROOT}
    # TODO: Generate ${FIRMWARE_BOOT_ROOT}/u-boot.img
    COMMAND touch ${FIRMWARE_BOOT_ROOT}/uEnv.txt
    COMMAND sh ${BOOT_TOOLS_DIR}/uEnv.txt.filler ${FIRMWARE_BOOT_ROOT}/uEnv.txt
    COMMAND cp -u ${BOOT_DIR}/config.txt ${FIRMWARE_BOOT_ROOT}/config.txt
    COMMAND cp -u ${BOOT_DIR}/cmdline.txt ${FIRMWARE_BOOT_ROOT}/cmdline.txt
    COMMAND cp -u ${BROADCOM_PRECOMPILED}/* ${FIRMWARE_BOOT_ROOT}/
    # TODO: Create and copy config.txt and other config files for RPi bootloaders
    WORKING_DIRECTORY ${UBOOT_SRC_DIR}
)

add_custom_target( bl-clean
    COMMAND make ${UBOOT_MAKE_PARAMS} distclean
    COMMAND rm -rf ${FIRMWARE_BOOT_ROOT}
    WORKING_DIRECTORY ${UBOOT_SRC_DIR}
)
