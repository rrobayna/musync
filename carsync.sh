#!/bin/bash
#####################################
# convert .flac to .mp3 recursively
# clean unused files for sync
# rsync files to a remote filesystem
# Written By Rafael Robayna
#
# @todo add support for converting other formats to mp3
# @todo fix all playlists so they are always relative 
# @todo check if mp3 tags are set and return a warning 
#
# Requirements:
# ffmpeg
#####################################

# Check that ffmpeg is installed 
hash ffmpeg 2>/dev/null || { echo >&2 "FFMPEG is required. Please install and try again.  Aborting."; exit 1; }

# Include Encoder functions
. $PWD/lib/audioSync.sh

###
# Source directory
# ex, /path/to/source 
# @param string
###
_source=/Users/rrobayna/Music/CarMusic

###
# Destination directory
# ex, /path/to/dest 
# @param string
###
_dest=/Volumes/TDI_MUSIC/


# Check if a target path was passed to the script
if [ $# -ge 1 ] && [ -d $1 ]; then 
    _source=$1
elif [ $# -ge 2 ] && [ -d $2]; then
    _dest=$2
fi

if [ ! -d $_source ]; then
    echo "Error: Source directory invalid $_source"
    echo "Aborting source processing"
else
    convert $_source
    clean $_source
fi

if [ ! -d $_dest ]; then
    echo "Error: destination directory invalid $_dest"
    echo "Aborting sync"
else
    rsync -rvc --delete-before $_source $_dest
    clean $_dest
fi
