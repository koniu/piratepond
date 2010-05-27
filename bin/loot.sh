#!/bin/sh
# loot.sh

# 1. Init
# -- Adjust these to your environment --
PLAYLISTPATH="/var/lib/mpd/playlists" # mpd's playlist path
MUSICPATH="/home/mxs/audio/" # mpd's music path
CDDEV="/dev/cdrw" 
# CD writer device # on the pirate machine the above is /dev/cdrw3
#CDDEV="/dev/hda"
CDDIR="/media/cdrom"
#CDDIR="/media/cdrom0"
USBDIR="/media/usb"
#USBDIR="/media/usbdisk"

# Don't bother about these ones
TIMESTAMP=`date +%s` # nanoseconds since 1970
PLAYLISTFILE=$PLAYLISTPATH/$TIMESTAMP.m3u # playlist file

# 2. Save and get absolute paths in the playlist file:
playlistsave () {
    mpc save $TIMESTAMP
    sed $PLAYLISTFILE -e 's/^/beginningofline/' > $PLAYLISTFILE.tmp
    rpl beginningofline $MUSICPATH $PLAYLISTFILE.tmp
    mv $PLAYLISTFILE.tmp $PLAYLISTFILE
}

# 3. Make CD (audio or data)
case "$1" in
    audio)
	playlistsave
	#mp3cd -v -n -d $CDDEV $PLAYLISTFILE
	# DEBUG MODE BELOW
	mp3cd -v -n -d $CDDEV $PLAYLISTFILE
	;;
    data)
	# THIS IS UNTESTED
	playlistsave
	rm /tmp/loot.iso
	genisoimage -o /tmp/loot.iso `cat $PLAYLIST`
	cdrecord /tmp/loot.iso
	;;
    upload)
#	find /media/usb/ -name "*.mp3" -exec cp -v '{}' /share/music/upload
	mkdir /share/music/upload/$TIMESTAMP
	rsync --progress -r --include='*.mp3|*.ogg|*.flac|*.wav' /media/usb /share/music/upload/$TIMESTAMP
	mpc update
	;;
    download)
	playlistsave
	mkdir /media/usb/$TIMESTAMP
    	rsync --progress -r --include-from=$PLAYLISTFILE /share/music/ /media/usb/$TIMESTAMP/.
	;;
    *)
	echo "Usage: './cdloot.sh data' or './cdloot.sh audio' or './cdloot.sh upload' or './cdloot.sh download'"
esac


