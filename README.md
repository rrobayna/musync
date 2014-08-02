musync - mu(sic) sync helper
==

Bash script to automate music audio conversion and syncronization between sources. It currently only supports flac to mp3 conversion and syncronization between two sources.

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
