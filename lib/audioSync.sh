#!/bin/bash
###
# Audio Sync Tools
# written by: Rafael L Robayna <rrobayna@gmail.com>
###


###
# Clean folder and all subfolders of extra files
#
# @param string path
# @return void
###
clean() {

    if [ ! -d $1 ]; then
        echo "Error: Target path invalid $1"; exit 1
    fi

    echo "######################################"
    echo "# Scanning path to clean junk files"

    #find $1 -name *.m3u -print0 | xargs -0 rm -rf
    #find $1 -name ".DS_Store" -print0 | xargs -0 rm -rf
    find $1 -name ".thumbnails" -print0 | xargs -0 rm -rf
    find $1 -name ".webviews" -print0 | xargs -0 rm -rf
    find $1 -name *.jpg -print0 | xargs -0 rm -rf
    find $1 -name *.jpeg -print0 | xargs -0 rm -rf
    find $1 -name *.png -print0 | xargs -0 rm -rf
    find $1 -name *.txt -print0 | xargs -0 rm -rf
    find $1 -name *.pdf -print0 | xargs -0 rm -rf
    find $1 -name *.nfo -print0 | xargs -0 rm -rf
    find $1 -name *.url -print0 | xargs -0 rm -rf
    find $1 -name *.sfv -print0 | xargs -0 rm -rf
    find $1 -name *.zip -print0 | xargs -0 rm -rf
    find $1 -name *.cue -print0 | xargs -0 rm -rf
    find $1 -name ._* -print0 | xargs -0 rm -rf
    find . -type d -empty -exec echo Removing empty directory {} \; -exec rmdir {} \; 2> /dev/null
    echo "######################################"
    echo ""
}


###
# Recursively search the path for flac audio and convert it to mp3
#
# @param string path
# @return void
###
convert() {
    
    if [ ! -d $1 ]; then
        echo "Error: Target path invalid $1"; exit 1
    fi

    echo "######################################"
    echo "# Scanning path to convert audio"
    echo "# "

    ###
    # Root directory path
    # @param string
    ###
    _path=$1

    ###
    # MP3 encoding bitrate
    # @param string
    ###
    _bitrate=320k
    if [[ $# -ge 2 ]]; then
        _bitrate=$2
    fi

    ###
    # Delete origional file
    # @param boolean
    ###
    _delete_origional=true
    if [[ $# -ge 3 ]]; then
        _delete_origional=$3
    fi

    _count=0

    #find -E $_path -type f -iregex '.*\.(flac|wma)$' | while read file; do
    #find $_path -type f -iname '*.flac'

    find $_path -type f -iname '*.flac' | while read file; do

        _filepath="${file%.[Ff][Ll][Aa][Cc]}"
        _newfile="$_filepath.mp3"
        
        # Don't overwrite exiting mp3 
        [ -f "$_newfile" ] && continue

        echo "# "
        echo "# Converting: $file"
        echo "# "

        ffmpeg -i "$file" -ab $_bitrate -vsync 2 "$_newfile" < /dev/null > /dev/null 
        wait

        [ "$_delete_origional" = false ] && continue

        # Check that the old file is safe to delete
        _oldfile_size=$(du -k "$file" | cut -f 1)
        _expected_size=$(( $_oldfile_size / 10 ))
        _file_size=$(du -k "$_newfile" | cut -f 1)
        if [[ -z "$_file_size" ]]; then _file_size=1; fi
        if [ $_file_size -gt $_expected_size ]; then
            rm "$file"
            _count=$(($_count + 1))
        else
            echo "Error encoding file: $_newfile"
            exit 0
        fi

    done

    echo "# $_count files converted to mp3"
    echo "######################################"
    echo ""

}

checkTags() {
    echo "Checking $1 for missing tags"

    find $_path -depth -name '*' | while read file; do

        if [[ "${file##*.}" == "mp3" ]]; then

            _output=$(ffmpeg -i $file | grep -ir "name")
            echo $_output
            #_filepath="${file%.[Ff][Ll][Aa][Cc]}"
            #_newfile="$_filepath.mp3"
            #
            ## Don't overwrite exiting mp3 
            #[ -f "$_newfile" ] && continue

            #echo "\n\n"
            #echo "###########################"
            #echo "Converting file to mp3"
            #echo "$file"
            #echo "###########################"
            #echo "\n"

            #ffmpeg -i "$file" -ab "$_bitrate" -vsync 2 "$_newfile" < /dev/null

            #[ "$_delete_origional" = false ] && continue

            ## Check that the old file is safe to delete
            #_filesize=$(du -k "$_newfile" | cut -f 1)
            #if [ $_filesize -gt 100 ]; then
            #    rm "$file"
            #else
            #    echo "Error encoding file: $_newfile"
            #    exit 0
            #fi
        fi
    done
}
