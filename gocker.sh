#!/bin/sh
# GCD Docker helper
# Appropriately named Gocker.
#
# A very small litte script that I ( Roger ) wrote up because
# writing the docker commands constantly kept getting annoying.
#
# Either place the script in /bin/ or root directory of the project.
# I much prefer /bin/ for global acces, meaning you don't have to be
# in the project folder interact with your containers
# 
# For windows users, make sure you use this from your Docker compatibility
# layer, which will make things a lot easier.

function main {
    if [ "$#" -lt 1 ]; then
        echo "Need more arguments, refer to the help menu:";
        printHelp;
        exit;
    fi

    if [ "$1" == "up" ]; then
        up "${@:2}";
    elif [[ "$1" == "halt" ]] || [[ "$1" == "down" ]]; then
        down "${@:2}";
    elif [[ "$1" == "ssh" ]] || [[ "$1" == "shell" ]] || [[ "$1" == "bash" ]]; then
        execute "-it" "${@:2}" "/bin/bash";
    elif [ "$1" == "run" ]; then
        execute "${@:2}";
    else
        echo "Not a valid command, refer to the help menu:";
        printHelp;
    fi
}

function up {
    docker start "$@";
}

function down {
   docker kill "$@";
}

function execute {
    docker exec "$@";
}

function printHelp {
    echo "I'm helping!";
}

main "$@";
