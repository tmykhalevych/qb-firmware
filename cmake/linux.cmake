add_custom_target( os-prepare
    if (NATIVECOMP)
        COMMAND make ${DEFCONFIG}
    else ()
        COMMAND make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} ${DEFCONFIG}
    endif ()
)

add_custom_target( os-build
    if (NATIVECOMP)
        COMMAND make -j4 zImage modules dtbs
        COMMAND make modules_install
        COMMAND cp arch/arm/boot/dts/*.dtb /boot/
        COMMAND cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
        COMMAND cp arch/arm/boot/dts/overlays/README /boot/overlays/
        COMMAND cp arch/arm/boot/zImage /boot/$KERNEL.img
    else ()
        COMMAND make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} zImage modules dtbs
    endif ()
)
