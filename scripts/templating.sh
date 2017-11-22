#!/usr/bin/env bash

# Simple templating code which uses Bash (sh?) and envsubst
# Usage:
# source it in the entry point e.g.: . ./templating.sh

require () {
    var_name=$1
    # Read form dynamic variable name
    # ${!var_name} in Bash but this is Ash
    eval 'val=$'${var_name}
    test -z ${val} && echo "Missing ${var_name}" && exit 1
    echo  "${var_name}=${val}"
}

replace_in_file () {
    file=$1
    test -z ${file} && echo "File ${file} not set" && exit 1
    test ! -e ${file} && echo "File ${file} not found" && exit 1
    shift

    for name in "${@}"
    do
        require ${name}
        echo "Replacing ${name} in ${file}"
        cat ${file} | envsubst "\$${name}" > .tmp-file
        cat .tmp-file > ${file}
        rm .tmp-file
    done
}