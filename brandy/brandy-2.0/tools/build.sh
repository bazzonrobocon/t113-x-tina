#!/bin/bash

#
#build.sh for uboot/spl
#wangwei@allwinnertech
#

TOP_DIR=$(cd `dirname $0`;pwd;cd - >/dev/null 2>&1)
BRANDY_SPL_DIR=$TOP_DIR/spl
BRANDY_SPL_PUB_DIR=$TOP_DIR/spl-pub
SPL_OLD=$(grep  ".module.common.mk"  ${BRANDY_SPL_DIR}/Makefile)
UBOOT_NAME=""   # eg: u-boot-2023
UBOOT_DIR=""
UBOOT_VER=""
UBOOT_BSP_DIR="$TOP_DIR/u-boot-bsp"
UBOOT_CONFIGS_PRE_DIR="configs"
set -e

_MAKE=$TOP_DIR/tools/make_dir/make4.1/bin/make
echo "_MAKE PATH: $_MAKE"

get_sys_config_name()
{
	[ -f $UBOOT_DIR/.config ] && \
	awk -F '=' '/CONFIG_SYS_CONFIG_NAME=/{print $2}' $UBOOT_DIR/.config | sed 's|"||g'
}

show_help()
{
	printf "\nbuild.sh - Top level build scritps\n"
	echo "Valid Options:"
	echo "  -h  Show help message"
	echo "  -t install gcc tools chain"
	echo "  -o build,e.g. uboot,spl,clean"
	echo "  -p <platform> platform, e.g. sun8iw18p1,  sun5i, sun6i, sun8iw1p1, sun8iw3p1, sun9iw1p1"
	echo "  -m mode,e.g. nand,mmc,nor"
	echo "  -c copy,e.g. any para"
	echo "example:"
	echo "./build.sh -o uboot -p sun8iw18p1"
	echo "./build.sh -o spl -p sun8iw18p1 -m nand"
	echo "./build.sh -o spl -p sun8iw18p1 -m nand -c copy"
	printf "\n\n"
}

prepare_toolchain()
{
	local ARCH="arm";
	local GCC="";
	local GCC_PREFIX="";
	local toolchain_archive_arm="./tools/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz";
	local tooldir_arm="./tools/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi";

	echo "Prepare toolchain ..."

	if [ ! -e "${tooldir_arm}/.prepared" ]; then
		rm -rf "${toolchain_arm}"
		mkdir -p ${tooldir_arm} || exit 1
		tar --strip-components=1 -xf ${toolchain_archive_arm} -C ${tooldir_arm} || exit 1
		touch "${tooldir_arm}/.prepared"
	fi
}

function build_clean()
{
	(cd $TOP_DIR/spl; $_MAKE distclean)
	(cd $TOP_DIR/spl-pub; $_MAKE distclean)
	(cd $UBOOT_DIR; $_MAKE distclean)
}

build_uboot_once()
{
	local defconfig=$1
	local CONFIG_SYS_CONFIG_NAME=$(get_sys_config_name)
	if [ "x${defconfig}" = "x" ];then
		echo "please set defconfig"
		exit 1
	fi
	echo build for ${defconfig} ...
	(
	cd $UBOOT_NAME/
	if [ -f .tmp_defcofig.o.md5sum ];then
		last_defconfig_md5sum=$(awk '{printf $1}' ".tmp_defcofig.o.md5sum")
	fi
	if [ -f .config ];then
		cur_defconfig_md5sum=$(md5sum "${UBOOT_CONFIGS_PRE_DIR}/${defconfig}" | awk '{printf $1}')
		if [ "x${CONFIG_SYS_CONFIG_NAME}" != "x${PLATFORM}" ];then
			$_MAKE distclean
			$_MAKE ${defconfig}
		elif [ "x${last_defconfig_md5sum}" != "x${cur_defconfig_md5sum}" ];then
			$_MAKE ${defconfig}
		fi
	else
		$_MAKE distclean
		$_MAKE ${defconfig}
	fi
	$_MAKE -j16
	)
}

function uboot_create_links()
{
	#cd $UBOOT_DIR
	#git checkout .
	#git clean -dfx
	#cd -

	rm -f $UBOOT_DIR/bsp
	ln -sfr ${UBOOT_BSP_DIR}/ $UBOOT_DIR/bsp
}

function build_uboot()
{
	echo "uboot version:${UBOOT_NAME}"
	local UBOOT_CONFIG_DIR=$UBOOT_DIR/${UBOOT_CONFIGS_PRE_DIR}
	if [ "x${PLATFORM}" = "xall" ];then
		if [ "x${UBOOT_VER}" = "x2023" ];then
			UBOOT_CONFIG_DIR=${UBOOT_BSP_DIR}/${UBOOT_CONFIGS_PRE_DIR}
		fi
		for defconfig in `ls $UBOOT_CONFIG_DIR`;do
			if [[ $defconfig =~ .*_defconfig$ ]];then
				build_uboot_once $defconfig
			fi
		done
	else
	    if [ "x${LICHEE_FLASH}" = "x" ];then
		for defconfig in `ls $UBOOT_DIR/${UBOOT_CONFIGS_PRE_DIR}/${PLATFORM}_*`;do
			if [[ $defconfig =~ .*_defconfig$ ]];then
				build_uboot_once ${defconfig##*/}
			fi
		done
	    elif [ "x${LICHEE_FLASH}" = "xdefault" ];then
		build_uboot_once ${PLATFORM}_defconfig
		#spi nor need same offset in different bin(one for burn, one for load), check if they are the same
		local NOR_UBOOT_OFFSET=(0 0 0 0)
		local NOR_LOGICAL_OFFSET=(0 0 0 0)
	    elif [ "x${LICHEE_FLASH}" = "xnor" ];then
			if [ -e $UBOOT_DIR/${UBOOT_CONFIGS_PRE_DIR}/${PLATFORM}_nor_defconfig ]; then
				build_uboot_once ${PLATFORM}_defconfig
				NOR_UBOOT_OFFSET[0]=`grep CONFIG_SPINOR_UBOOT_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				NOR_LOGICAL_OFFSET[0]=`grep CONFIG_SPINOR_LOGICAL_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				NOR_UBOOT_OFFSET[2]=`grep CONFIG_SPINOR_UBOOT_SECURE_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				NOR_LOGICAL_OFFSET[2]=`grep CONFIG_SPINOR_LOGICAL_SECURE_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				build_uboot_once ${PLATFORM}_nor_defconfig
				NOR_UBOOT_OFFSET[1]=`grep CONFIG_SPINOR_UBOOT_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				NOR_LOGICAL_OFFSET[1]=`grep CONFIG_SPINOR_LOGICAL_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				if [  ${NOR_UBOOT_OFFSET[0]} -ne ${NOR_UBOOT_OFFSET[1]} ]; then
					echo "UBOOT OFFSET NOT MATCH, burn to ${NOR_UBOOT_OFFSET[0]}, load from ${NOR_UBOOT_OFFSET[1]}"
					exit 1
				fi
				if [  ${NOR_LOGICAL_OFFSET[0]} -ne ${NOR_LOGICAL_OFFSET[1]} ]; then
					echo "LOGICAL OFFSET NOT MATCH, burn to ${NOR_LOGICAL_OFFSET[0]}, load from ${NOR_LOGICAL_OFFSET[1]}"
					exit 1
				fi
			else
				echo "Cant find ${PLATFORM}_nor_defconfig"
				exit 1
			fi
			if [ -e $UBOOT_DIR/${UBOOT_CONFIGS_PRE_DIR}/${PLATFORM}_nor_secure_defconfig ]; then
				build_uboot_once ${PLATFORM}_nor_secure_defconfig
				NOR_UBOOT_OFFSET[3]=`grep CONFIG_SPINOR_UBOOT_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				NOR_LOGICAL_OFFSET[3]=`grep CONFIG_SPINOR_LOGICAL_OFFSET $UBOOT_NAME/.config |awk -F = '{print $2}'`
				if [ ${NOR_UBOOT_OFFSET[2]} -ne ${NOR_UBOOT_OFFSET[3]} ]; then
					echo "SECURE UBOOT OFFSET NOT MATCH, burn to ${NOR_UBOOT_OFFSET[2]}, load from ${NOR_UBOOT_OFFSET[3]}"
					exit 1
				fi
				if [ ${NOR_LOGICAL_OFFSET[2]} -ne ${NOR_LOGICAL_OFFSET[3]} ]; then
					echo "SECURE LOGICAL OFFSET NOT MATCH, burn to ${NOR_LOGICAL_OFFSET[2]}, load from ${NOR_LOGICAL_OFFSET[3]}"
					exit 1
				fi
			fi
	    else
		echo "unsupport flash mode"
		exit 2
	    fi
	fi
}

function build_spl-pub_once()
{
	board=$1
	mode=$2
	path=$3
	(
	cd ${path}

	if [ "x${mode}" = "xall" ];then
		echo --------build for mode:${mode} board:${board}-------------------
		$_MAKE distclean
		$_MAKE b=${board}  ${CP}
		$_MAKE -j ${CP}
	else
		echo --------build for mode:${mode} board:${board}-------------------
		$_MAKE distclean
		$_MAKE b=${board} m=${mode}  ${CP}
		case ${mode} in
			nand | mmc | spinor)
				$_MAKE boot0 -j ${CP}
				;;
			sboot_nor)
				echo "Neednot build sboot_nor ..."
				;;
			*)
				$_MAKE ${mode} -j ${CP}
				;;
		esac
	fi
	)
}


function build_spl-pub()
{
	if [ "x${BOARD}" = "xall" ];then
		for board in `ls $TOP_DIR/$1/board`;do
			if [ "x${MODE}" = "xall" ];then
				build_spl-pub_once ${board} all $1
			else
				build_spl-pub_once ${board} ${MODE} $1
			fi
		done
	elif [ "x${MODE}" = "xall" ];then
		build_spl-pub_once ${BOARD} all $1
	else
		build_spl-pub_once ${BOARD} ${MODE} $1
	fi
}

function build_spl_once()
{
	platform=$1
	mode=$2
	path=$3
	support_board_exit=`cat $TOP_DIR/${path}/board/${platform}/common.mk | grep -w "SUPPORT_BOARD" | awk -F= '{printf $2}'`
	if [ "x${BOARD}" != "xall" ];then
		suport_board=${BOARD}
	elif [ "x${support_board_exit}" = "x" ];then
		suport_board=null
	else
		suport_board=`cat $TOP_DIR/${path}/board/${platform}/common.mk | grep -w "SUPPORT_BOARD" | awk -F= '{printf $2}'`
	fi
	echo "suport_board:${suport_board}"
	(
	cd ${path}

	for board in ${suport_board};do
		if [ "x${mode}" = "xall" ];then
			echo --------build for platform:${platform} mode:${mode} board:${board}-------------------
			$_MAKE distclean
			$_MAKE p=${platform} b=${board} ${CP}
			$_MAKE -j b=${board} ${CP}
		else
			echo --------build for platform:${platform} mode:${mode} board:${board}-------------------
			$_MAKE distclean
			$_MAKE p=${platform} m=${mode} b=${board} ${CP}
			case ${mode} in
				nand | mmc | spinor)
					$_MAKE boot0 -j b=${board} ${CP}
					;;
				sboot_nor)
					echo "Neednot build sboot_nor ..."
					;;
				*)
					$_MAKE ${mode} -j b=${board} ${CP}
					;;
			esac
		fi
	done
	)
}


function build_spl()
{
	local CONFIG_SYS_CONFIG_NAME=$(get_sys_config_name)
	if [ ! -d $TOP_DIR/$1/board/${PLATFORM} ] && [ "x${PLATFORM}" != "xall" ];then
		PLATFORM=${CONFIG_SYS_CONFIG_NAME}
	fi
	if [ "x${PLATFORM}" = "xall" ];then
		for platform in `ls $TOP_DIR/$1/board`;do
			if [ "x${MODE}" = "xall" ];then
				build_spl_once ${platform} all $1
			else
				build_spl_once $platform ${MODE} $1
			fi
		done
	elif [ "x${MODE}" = "xall" ];then
		build_spl_once ${PLATFORM} all $1
	else
		build_spl_once ${PLATFORM} ${MODE} $1
	fi
}

function build_spl_old()
{
	if [ "x${PLATFORM}" = "xall" ];then
		for platform in `ls $TOP_DIR/spl/board`;do
			if [ "x${MODE}" = "xall" ];then
				for mode in `ls ${TOP_DIR}/spl/board/${platform}`;do
					if [[ $mode =~ .*\.mk$ ]]  \
					&& [ "x$mode" != "xcommon.mk" ];then
						mode=${mode%%.mk*}
						build_spl_once ${platform} ${mode} $1
					fi
				done
			else
				build_spl_once $platform ${MODE} $1
			fi
		done
	elif [ "x${MODE}" = "xall" ];then
		for mode in `ls ${TOP_DIR}/spl/board/${PLATFORM}`;do
			if [[ $mode =~ .*\.mk$ ]]  \
			&& [ "x$mode" != "xcommon.mk" ];then
				mode=${mode%%.mk*}
				build_spl_once ${PLATFORM} ${mode} $1
			fi
		done
	else
		build_spl_once ${PLATFORM} ${MODE} $1
	fi
}

function build_all()
{
	build_uboot

	if [ -d ${BRANDY_SPL_PUB_DIR} ];then
		build_spl-pub spl-pub
        fi

	if [ -d ${BRANDY_SPL_DIR} ] && [ "x${SPL_OLD}" != "x" ] ; then
			[ "x${LICHEE_BRANDY_SPL}" != "x" ] && build_${LICHEE_BRANDY_SPL} ${LICHEE_BRANDY_SPL} || build_spl spl
	elif [ -d ${BRANDY_SPL_DIR} ] && [ "x${SPL_OLD}" = "x" ] ; then
		build_spl_old spl
	fi
}

[ -e ${TOP_DIR}/../../.buildconfig ] && source ${TOP_DIR}/../../.buildconfig

while getopts to:p:m:c:b:u: OPTION; do
	case $OPTION in
	t)
		prepare_toolchain
		exit $?
		;;
	o)
		prepare_toolchain
		if [ "x${SPL_OLD}" = "x" ] && [ "x$OPTARG" = "xspl" ]; then
			command="build_spl_old $OPTARG"
		else
			command="build_$OPTARG $OPTARG"
		fi
		;;

	p)
		prepare_toolchain
		PLATFORM=$OPTARG
		;;
	m)
		MODE=$OPTARG
		;;
	c)
		CP=C\=$OPTION
		;;
	b)
		BOARD=$OPTARG
		;;
	u)
		UBOOT_VER=$OPTARG
		;;
	*)
		show_help
		exit $?
		;;
	esac
done

#get uboot version from -u or LICHEE_BRANDY_UBOOT_VER, default 2018
if [ "x${UBOOT_VER}" = "x" ];then
	UBOOT_VER=${LICHEE_BRANDY_UBOOT_VER}
fi
if [ "x${UBOOT_VER}" = "x" ];then
	UBOOT_VER="2018"
fi

UBOOT_NAME="u-boot-${UBOOT_VER}"
UBOOT_DIR="$TOP_DIR/$UBOOT_NAME"
if ! [ -d $UBOOT_DIR ];then
	echo "Build error: can not find uboot dir: $UBOOT_DIR "
fi
if [ "x${UBOOT_VER}" != "x2018" ];then
	echo "Independent BSP for $UBOOT_NAME"
	UBOOT_INDEPENDENT_BSP=true
	UBOOT_CONFIGS_PRE_DIR="bsp/configs"
fi

if [ "x${PLATFORM}" = "x" ];then
	PLATFORM=all
fi
if [ "x${MODE}" = "x" ];then
	MODE=all
fi
if [ "x${BOARD}" = "x" ];then
	BOARD=all
fi
# echo "PLATFORM:${PLATFORM}  MODE:${MODE}  CP:${CP}  BOARD:${BOARD} "
if [ "x${UBOOT_INDEPENDENT_BSP}" = "xtrue" ];then
	uboot_create_links
fi

if [ "x$command" != "x" ];then
	$command
else
	build_all
fi
exit $?
