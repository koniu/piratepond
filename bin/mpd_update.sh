#!/bin/sh
# this script updates mpd database and shows awesome popups

# dump statistics
songs=`mpc stats | grep Songs | cut -d\  -f5`

# show notification and save its id
./awnotify.sh "Updating MPD database..." "" 0
id=$?

# update mpd db
mpc update > /dev/null

# monitor update
while [ -n "$(mpc | grep Updating)" ] ; do sleep 2 ; done

# calculate change in song num.
newsongs=`mpc stats | grep Songs | cut -d\  -f5`
delta=$[newsongs - songs]

# show notification
./awnotify.sh "Update finished\nChange in number of songs: $delta" "" "" $id >& /dev/null
