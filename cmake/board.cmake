include_guard(GLOBAL)

if (NOT BOARD)
    message("== Set default BIARD to Raspberry Pi 3")
    set(BOARD rp3)
endif ()

if ((BOARD STREQUAL rp1) OR (BOARD STREQUAL rp0) OR (BOARD STREQUAL cm))
    set(CMAKE_SYSTEM_PROCESSOR arm11) #FIXME: Need to validate if it is a valid value
    set(KERNEL kernel)
    set(DEFCONFIG bcmrpi_defconfig)
    set(UBOOT_DEFCONFIG rpi_defconfig)
    set(ARCH arm)

elseif (BOARD STREQUAL rp0w)
    set(CMAKE_SYSTEM_PROCESSOR arm11) #FIXME: Need to validate if it is a valid value
    set(KERNEL kernel)
    set(DEFCONFIG bcmrpi_defconfig)
    set(UBOOT_DEFCONFIG rpi_0_w_defconfig)
    set(ARCH arm)

elseif (BOARD STREQUAL rp2)
    set(CMAKE_SYSTEM_PROCESSOR cortex-a7)
    set(KERNEL kernel7)
    set(DEFCONFIG bcm2709_defconfig)
    set(UBOOT_DEFCONFIG rpi_2_defconfig)
    set(ARCH arm)

elseif (BOARD STREQUAL rp2b12)
    set(CMAKE_SYSTEM_PROCESSOR cortex-a53)
    set(KERNEL kernel7)
    set(DEFCONFIG bcm2709_defconfig)
    set(UBOOT_DEFCONFIG rpi_2_defconfig)
    set(ARCH arm)

elseif ((BOARD STREQUAL rp3) OR (BOARD STREQUAL cm3))
    set(CMAKE_SYSTEM_PROCESSOR cortex-a53)
    set(KERNEL kernel7)
    set(DEFCONFIG bcm2709_defconfig)
    set(UBOOT_DEFCONFIG rpi_3_defconfig)
    set(ARCH arm)

elseif (BOARD STREQUAL rp4)
    set(CMAKE_SYSTEM_PROCESSOR cortex-a72)
    set(KERNEL kernel7l)
    set(DEFCONFIG bcm2711_defconfig)
    set(UBOOT_DEFCONFIG rpi_4_defconfig) #FIXME: Could be invalid
    set(ARCH arm)
endif ()
