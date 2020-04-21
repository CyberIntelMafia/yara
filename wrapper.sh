#!/bin/bash
# Purpose: Wrapper for Yara
# Created By: Richard Jackson
# Date Created: 21/04/2020

error(){
	printf "\033[35mERROR:\t\033[31m${1}!\033[0m\n"
	exit 1
}

info(){
	printf "\033[35mINFO:\t\033[35m${1}.\033[0m\n"
}

install_dependencies(){
	for w in 'first-attempt' 'second-attempt'
	do
		printf "\033[35mExecuting, ${w}\033[0m\n"
		apt-get update
		apt-get -y install bison autoconf
	done
}

install_yara(){
	yara_src=yara
	yara_dest=/usr/bin
	if [ -e "${yara_src}" ];
	then
		if [ ! -e "${yara_dest}" ];
		then
			info "Installing yara to -> /usr/bin"
			cp -a -v ${yara_src} ${yara_dst}
		else
			printf "\033[35mYara is already installed\033[0m\n"
			read -p "Replace older version? [y|Y|yes|Yes]" confirm
			_confirm=$( echo "${confirm}" | tr '[:upper:]' '[:lower:]')
			case "${_confirm}" in
				y|yes) rm -fv ${yara_dest}/yara
				cp -a -v $yara_src $yara_dest
				;;
				*) info "No action was taken";;
			esac
		fi
	else
		error "Missing 'yara' program"
	fi
	exit 0
}

compile_yara(){
	if [ -e "build.sh" ];
	then
		./build.sh
	fi
}

help_menu(){
	printf "\033[36mWrapper: Yara Installation Tools\033[0m\n"
	printf "\033[35mInstall Yara\t[ -iy, --iy, -install-yara, --install-yara ]\033[0m\n"
	printf "\033[35mInstall Deps\t[ -id, --id, -install-dep, --install-dep ]\033[0m\n"
	printf "\033[35mCompile Yara\t[ -c, -compile, --compile ]\033[0m\n"
	exit 0
}

if [ ${#@} -gt 0 ];
then
	for args in $@
	do
		case $args in
			--help|-help|-h|help) help_menu;;
			--install-yara|-install-yara|\
			--iy|-iy) _yara_install='yes';;
			--install-dep|-install-dep|\
			--id|-id) _yara_dep='yes';;
			-c|--compile|--compile)
			_yara_compile='yes'
			;;
		esac
	done
else
	error "Missing parameter"
fi

case "${_yara_dep}" in
	yes) install_dependencies;;
esac

case "${_yara_install}" in
	yes) install_yara;;
esac

case "${_yara_compile}" in
	yes) compile_yara;;
esac

if [ ${#@} -gt 1 ];
then
	help_menu
	error "Invalid parameter was entered"
fi


################### END OF SCRIPT ###################
