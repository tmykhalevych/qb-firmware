if (NATIVECOMP)
    message("== Set NATIVE COMPILING mode")
else ()
    message("== Set CROSS COMPILING as a default mode")
    set(ARCH arm)
    set(CROSS_COMPILE arm-linux-gnueabihf-)
endif ()

if (NOT BOARD)
    message("== Set default BIARD to Raspberry Pi 3")
    set(BOARD rp3)
endif ()

if ((BOARD STREQUAL rp1) OR (BOARD STREQUAL rp0) OR (BOARD STREQUAL rp0w) OR (BOARD STREQUAL cm))
    set(CMAKE_SYSTEM_PROCESSOR arm11) #FIXME: Need to validate if it is a valid value
    set(KERNEL kernel)
    set(DEFCONFIG bcmrpi_defconfig)

elseif (BOARD STREQUAL rp2)
    set(CMAKE_SYSTEM_PROCESSOR cortex-a7)
    set(KERNEL kernel7)
    set(DEFCONFIG bcm2709_defconfig)

elseif ((BOARD STREQUAL rp2b12) OR (BOARD STREQUAL rp3) OR (BOARD STREQUAL cm3))
    set(CMAKE_SYSTEM_PROCESSOR cortex-a53)
    set(KERNEL kernel7)
    set(DEFCONFIG bcm2709_defconfig)

elseif (BOARD STREQUAL rp4)
    set(CMAKE_SYSTEM_PROCESSOR cortex-a72)
    set(KERNEL kernel7l)
    set(DEFCONFIG bcm2711_defconfig)

endif ()

set(BOARD_BUILD_DIR ${PROJECT_BUILD_DIR}/${BOARD})
