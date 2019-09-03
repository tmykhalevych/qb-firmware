include_guard(GLOBAL)

set(BOOT_DIR ${PROJECT_SOURCE_DIR}/os/boot)
set(BROADCOM_PRECOMPILED ${BOOT_DIR}/broadcom)

add_custom_target( bl-build # bl for bootloader
    COMMAND mkdir -p ${FIRMWARE_BOOT_ROOT}
    COMMAND cp -u ${BOOT_DIR}/config.txt ${FIRMWARE_BOOT_ROOT}/config.txt
    COMMAND cp -u ${BOOT_DIR}/cmdline.txt ${FIRMWARE_BOOT_ROOT}/cmdline.txt
    COMMAND cp -u ${BROADCOM_PRECOMPILED}/* ${FIRMWARE_BOOT_ROOT}/
    WORKING_DIRECTORY ${BOOT_DIR}
)

add_custom_target( bl-clean
    COMMAND rm -rf ${FIRMWARE_BOOT_ROOT}
    WORKING_DIRECTORY ${BOOT_DIR}
)
