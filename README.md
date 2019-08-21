# qb
Simple Linux based firmware for the Raspberry Pi satellite.

## Dependencies installation
First of all, you need to get the Linux, which is a submodule. If you are doing that first time, you should run:
```
user@project-dir: git submodule init
```
Where `project-dir` is just the root directory of this project.
Then you need to update the submodules:
```
user@project-dir: git submodule update --recursive
```

### Build requirements
1) Make sure that you have all applications required:
```
user@project-dir: sudo apt-get updare
user@project-dir: sudo apt-get install cmake git make bc bison flex libssl-dev
```
2) Get the toolchain for cross compiling the project, locate it at `~/tools` directory:
```
user@project-dir git clone https://github.com/raspberrypi/tools ~/tools
```
3) Get the Linaro `gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu` toolchain from the [Linaro Releases](https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/) page, unzip it and locate at `~/tools` as well. It is needed to compile qb applications using C++17 standard.

### Bootloader
This project uses [U-Boot](https://github.com/u-boot/u-boot) as a second stage bootloader. It is linked as a submodule and located at `project-dir/boot/u-boot` folder.

## How to build
It is preferable to build all Linux/qb stuff as a root user, so:
```
user@project-dir: sudo -s
```

Primarily, you need to create a directory for all build output. You can create it inside or outside the project directory, as you wish, but the default place is `./build`, it is [ignored](.gitignore) specially for that purpose.

```
root@project-dir: mkdir build && cd build
```
`project-dir` is just the root directory of this project.

After that you ought to generate the Makefiles for the firmware. The project uses `cmake` as a build system, so you can generate a lot of project files for many IDE's or just bare Unix Makefiles. The last one is more clearer and preferable. Also you have to define some cmake constants to specify build configuratios:
* `CMAKE_TOOLCHAIN_FILE='cmake/toolchain.cmake'`
* `BOARD='board'`, where `board` value is an ID for different Raspberry Pi models, such as:
    * `rp0` - for the Raspberry Pi Zero,
    * `rp0w` - for the Raspberry Pi Zero W,
    * `rp1` - for the Raspberry Pi 1,
    * `rp2` - for the Raspberry Pi 2,
    * `rp2b12` - for the Raspberry Pi 2 Model B v1.2,
    * `rp3` - for the Raspberry Pi 3,
    * `rp4` - for the Raspberry Pi 4,
    * `cm` - for Compute Mudule 1,
    * `cm3` - for Compute Mudule 3/3Lite/3+/3+Lite.

You can explore [cmake/board.cmake](cmake/board.cmake) for more details about boards related build stuff. 

The first build step is to setup the build environment. There is a script, made for that:
```
root@build: source ../setup.env
```

Next, run cmake to generate the Makefiles, e.g.:
```
root@build: cmake -DCMAKE_TOOLCHAIN_FILE='cmake/toolchain.cmake' -DBOARD='rp3' -G "Unix Makefiles" ..
```

Now we can start the build (i prefer to do this into `project-dir`, but it is not mandatory):
```
root@build: cd ..
root@project-dir: BUILD_DIRECTORY_PATH=./build
```

Next, the Linux should be configured. For the project default configuration, run:
```
root@project-dir: cmake --build ${BUILD_DIRECTORY_PATH} --target os-configure
```

Now it is time to start the os and qb build processes:
```
root@project-dir: cmake --build ${BUILD_DIRECTORY_PATH} --target os-build
root@project-dir: cmake --build ${BUILD_DIRECTORY_PATH} --target install
```

To compose bootloaders, kernel, qb and auxiliary apps into `${BUILD_DIRECTORY_PATH}/firmware/` target directory, run:
```
root@project-dir: cmake --build ${BUILD_DIRECTORY_PATH} --target compose
```

Also, there are targets to clean all build output (separately for the Linux and qb):
```
root@project-dir: cmake --build ${BUILD_DIRECTORY_PATH} --target clean
root@project-dir: cmake --build ${BUILD_DIRECTORY_PATH} --target os-clean
```

You can explore [cmake/linux.cmake](cmake/linux.cmake) and [cmake/firmware.cmake](cmake/firmware.cmake) for more details about build targets.

### Build artifacts
This table describes where all build/compose artifacts should be:

| Artifacts | Path | 
| --- | --- | 
| All build artifacts | `${BUILD_DIRECTORY_PATH}/` | 
| Linux build output | `${BUILD_DIRECTORY_PATH}/linux/` | 
| Bootloaders and it's configs | `${BUILD_DIRECTORY_PATH}/firmware/boot/` | 
| Linux kernel image and device tree | `${BUILD_DIRECTORY_PATH}/firmware/kernel/` | 
| Root filesystem | `${BUILD_DIRECTORY_PATH}/firmware/rootfs/` | 
| All qb artifacts | `${BUILD_DIRECTORY_PATH}/firmware/rootfs/qb/` | 

## Maintainers
* Taras Mykhalevych (taras.mykhalevych@gmail.com)
