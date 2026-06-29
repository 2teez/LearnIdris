#!/usr/bin/env bash
# Date: 29/06/2026
# Description: A script for programming Idris
# Author: omitida
#

filename=

function usage() {
    echo "Usage: $0 <option> <filename>"
    echo "  "

    echo "Available options:"
    echo "------------------"
    echo "-c: compile the Idris file."
    echo "-d: delete the compiled executable."
    echo "-h: show this help message."
    echo "-o: generate standalone Idris file."
    echo "-r: run the compiled executable."
    exit 1
}

function check_file() {
    filename="${1}"
    file_extension="${filename##*.}"
    file_basename="${filename%.*}"
    [ "${file_extension}" != "idr" ] && { filename="${file_basename^}.idr"; }
}

IDRIS="module Main

main : IO ()
main = putStrLn \"Hello, World!\"
"

if [ "${#}" -ne 2 ]; then
    usage
fi

optionstring="c:d:o:r:h"
while getopts "${optionstring}" opt; do
    case $opt in
        c)
            filename="${OPTARG}"
            echo "Compiling $filename..."
            check_file "${filename}"

            idris2 "${filename}" -o "${filename%.*}"
            ;;

        d)
            filename="${OPTARG}"
            echo "Deleting compiled executable..."

            rm -rf "build"
            rm -f "${filename}"
            ;;
        o)
            filename="${OPTARG}"
            echo "Generating standalone Idris file..."
            check_file "${filename}"
            echo "$IDRIS" > "${filename}"

            idris2 "${filename}" -o "${filename%.*}"
            ./build/exec/"${filename%.*}"
            ;;
        r)
            filename="${OPTARG}"
            echo "Running compiled executable..."
            check_file "${filename}"

            idris2 "${filename}" -o "${filename%.*}"
            ./build/exec/"${filename%.*}"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            usage
            ;;
    esac
done
