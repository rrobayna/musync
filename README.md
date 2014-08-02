musync - mu(sic)sync helper
==

Bash script to automate converting audio in a specified folder from flac to mp3
and rsyncing that folder to a specified destination.

## Usage

```bash
musync <source> <destination>
```

## Configuration

To configure your source and destination folders create a .musync file in your
home folder and fill in the following information.

```bash
_SOURCE=/your/source/directory/
_DEST=/your/destination/directory/
```

## Requirements

ffmpeg, rsync
