# t113-x-tina

## Prerequisites
Docker installed on your system.

Make sure you have init submodule
```
git submodule init
git submodule update
```

## Build Steps
1) Build Docker Image 
```bash
./docker_build.sh
./docker_run.sh
```

2) Config board
```bash
./build.sh config
```
Select: 1 -> (1 or 2) -> 0 -> 4 -> 0

3) Start to build image
```bash
./build.sh
```

4) After building successfully, pack the image.
This is Allwinner-based Image, to convert this into regular image, we have to use [OpenixCard](https://github.com/YuzukiTsuru/OpenixCard)
```bash
./build.sh pack
```
