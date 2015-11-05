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
    elif [ "$1" == "status" ]; then
        status;
    elif [[ "$1" == "throw" ]] || [[ "$1" == "throwaway" ]] || [[ "$1" == "th" ]]; then
        throwaway "${@:2}";
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

function status {
up=`docker ps -q | wc -l`;
total=`docker ps -aq | wc -l`;
    docker ps;
    if [ $up -ne $total ]; then
        echo "$up/$total containers are running."
        echo "Would you like to [S]tart the non-running ones, [R]emove them, or [I]gnore this?";
        read in;
        if [[ "$in" == "s" ]] || [[ "$in" == "S" ]]; then
            echo 'Starting containers';
            docker start $(docker ps -qf status=exited);
            echo 'Done.';
        elif [[ "$in" == "r" ]] || [[ "$in" == "R" ]]; then
            echo 'Removing containers...';
            docker rm -f $(docker ps -qf status=exited);
            echo 'Done.';
        else
            echo 'Ignoring...';
        fi
    fi
}

function throwaway {
    if [ "$#" -lt 1 ]; then
        echo 'This function needs a command to run';
    fi
    docker run --rm -it ubuntu $1
}

main "$@";
