include(cmake/board.cmake)

set(UBOOT_SRC_DIR ${PROJECT_SOURCE_DIR}/boot/u-boot)
set(BOOT_TOOLS_DIR ${PROJECT_SOURCE_DIR}/boot/tools)
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
    COMMAND source ${BOOT_TOOLS_DIR}/uEnv.txt.filler ${FIRMWARE_BOOT_ROOT}/uEnv.txt
    # TODO: Download rpi-boot dependencies into boot/rpi-boot from https://github.com/raspberrypi/firmware/tree/master/boot
    WORKING_DIRECTORY ${UBOOT_SRC_DIR}
)

add_custom_target( bl-clean
    COMMAND make ${UBOOT_MAKE_PARAMS} distclean
    COMMAND rm -rf ${FIRMWARE_BOOT_ROOT}
    WORKING_DIRECTORY ${UBOOT_SRC_DIR}
)
