#!/bin/bash

set -e


function error() {
  echo " !     $*" >&2
  exit 1
}

function topic() {
  echo "-----> $*"
}

function indent() {
  c='s/^/       /'
  case $(uname) in
    Darwin) sed -l "$c";;
    *)      sed -u "$c";;
  esac
}

# manifest.yml
#  env:
#    PACKAGES: plotly_binary,etc-dependency
function check_PACKAGES_env_variable() {
    echo "Test staging-util.sh ##################"
    
    
    local PACKAGE_NAME_TO_CHECK=$1
    local FORCE_INSTALL=$2
    local DO_INSTALL="false"

    if [ "x$FORCE_INSTALL" == "xforce" ];  then
  	    DO_INSTALL="true"
	    echo $DO_INSTALL
	    exit
	fi

    if [ ! -z $PACKAGES ]; then
	    packages=$(echo $PACKAGES | tr "," "\n")
	    for package in $packages
	    do
            #echo $package
	        if [ "x$package" == "x$PACKAGE_NAME_TO_CHECK" ]; then
                #echo "match $package"
	   	        DO_INSTALL="true"
	   		    break
	        fi
	    done
    fi

    echo $DO_INSTALL
}
