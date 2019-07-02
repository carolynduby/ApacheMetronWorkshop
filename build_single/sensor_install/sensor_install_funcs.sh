#!/bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

read_config_vars() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        while IFS="=" read -r key value; do
            case "$key" in
                '#'*) ;;
                *)
                   eval ${key}=\${value}
                   export ${key}
            esac
        done < "$config_file"
    else
        echo "Config file " $config file " does not exist."
        exit
    fi
}
