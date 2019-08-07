if (NOT BUILD_TOOL_NAME)
    message(">> The BUILD_TOOL_NAME value has NOT been set, use default")
    set(BUILD_TOOL_NAME arm-linux-gnueabihf)
endif ()

if (NOT TOOLCHAIN_PATH)
    if (NOT TOOLCHAIN_DIR)
        message(">> The TOOLCHAIN_DIR value has NOT been set, use default")
        set(TOOLCHAIN_DIR ${PROJECT_SOURCE_DIR}/../tools)
    endif ()

    set(TOOLCHAIN_PATH ${TOOLCHAIN_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin)
elseif (TOOLCHAIN_DIR)
    message(">> The TOOLCHAIN_DIR value is ignored because TOOLCHAIN_PATH has already set")
endif ()

set(CMAKE_SYSTEM_NAME Linux)

set(CMAKE_CXX_COMPILER  ${TOOLCHAIN_PATH}/${BUILD_TOOL_NAME}-g++)
set(CMAKE_C_COMPILER    ${TOOLCHAIN_PATH}/${BUILD_TOOL_NAME}-gcc)
set(CMAKE_ASM_COMPILER  ${TOOLCHAIN_PATH}/${BUILD_TOOL_NAME}-gcc)
set(SIZE_COMMAND        ${TOOLCHAIN_PATH}/${BUILD_TOOL_NAME}-size)
set(OBJCOPY_COMMAND     ${TOOLCHAIN_PATH}/${BUILD_TOOL_NAME}-objcopy)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
