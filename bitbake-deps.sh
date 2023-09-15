#!/bin/bash
# Copyright: 2023 - Talel BELHAJSALEM (bhstalel@gmail.com)

#
#   Exit global function
#
#   ~ Export current PID
export THIS_PID=$$
#   ~ Trap the <TERM> signal command
trap "exit 1" TERM
trap "exit 1" SIGINT
#
die(){
    kill -s TERM ${THIS_PID}
}

ENABLE_DEBUG=${ENABLE_DEBUG:-0}
#
#   Log function
#   
#   Arguments:
#       > $1 = level
#       > $2 = message
#
do_log(){
    local level=$1
    local content=$2

    case ${level} in
        "info"|"INFO")
            echo -e "\e[32m[INFO] ${content}\e[0m";;
        "warn"|"WARN"|"WARNING")
            echo -e "\e[33m[WARN] ${content}\e[0m";;
        "debug"|"DEBUG")
            [ ${ENABLE_DEBUG} -eq 1 ] && (
                echo -e "\e[34m[DEBUG] ${content}\e[0m"
            );;
        "error"|"ERROR")
            echo -e "\e[31m[ERROR] ${content}\e[0m"
            die
        ;;
        *)
            echo -e "\e[31m[ERROR] ${level} not supported\e[0m"
            die
        ;;
    esac
}

PN_BUILDLIST="pn-buildlist"

#
# Check if source is set or not
#
do_check_env(){
    do_log debug "Checking if the environment is set .."
    BITBAKE_PATH=$(which bitbake)
    [[ (-z ${BUILDDIR}) || (-z ${BBPATH}) || (-z ${BITBAKE_PATH}) ]] && (
        do_log error "The bitbake environment is not set yet!"
    )
}

#
# Generate dependency list of the given recipe
# and remove it from the list itself to avoid bitbaking it.
#
do_gen_dep_list(){
    local recipe=$1
    do_log info "Generating ${PN_BUILDLIST} for recipe: ${recipe}"

    bitbake -g $recipe > /dev/null
    sed -i "/$recipe/d" ${PN_BUILDLIST}
}

#
# Run the given bitbake task on the given recipe's dep list
#
do_bitbake(){
    local task=$1
    local command="bitbake ${recipe}"

    do_log debug "Running bitbake on $(wc -l ${PN_BUILDLIST}) recipes .."
    while read recipe; do
        [ -z ${task} ] && (
            do_log info "Running full recipe ${recipe}"
        )|| (
            do_log info "Running task ${task} on recipe ${recipe}"
            command+=" -c ${task}"
        )
        # Disable output if DEBUG is disabled
        [ ${ENABLE_DEBUG} -eq 0 ] && command+=" > /dev/null"

        # Run command
        eval ${command}
    done < ${PN_BUILDLIST}
}

do_usage(){
    do_log error "Usage: $1 recipe [task]"
}

#
#   Check if recipe and task are given
#
do_sanity(){
    do_log debug "Checking passed arguments .."
    [[ ($# -eq 0) || ($# > 2) ]] && do_usage $0
}

#
#   Main function
#
do_main(){
    local recipe=$1
    local task=$2

    do_sanity $@
    do_check_env
    do_gen_dep_list ${recipe}
    do_bitbake ${task}
}

do_main $@