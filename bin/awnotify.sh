#!/bin/sh
# Usage: notify.sh "text of notification" [title] [timeout] [replaces_id]
# returns awesome popup id (useful for replacing)

# process args
if [ "$1" == "-" ]; then while read t; do text="$text$t\\n"; done; else text="$1"; fi
if [ ! -z "$2" ]; then title=", title='$2'"; fi
if [ ! -z "$3" ]; then timeout=", timeout=$3"; fi
if [ ! -z "$4" ]; then replaces_id=", replaces_id=$4"; fi

# show popup
id=$(echo "local n = naughty.notify{text=awful.util.escape('`echo -n $text`') $title $timeout $replaces_id}; return(n.id)" | awesome-client | cut -d\   -f5)
exit $id
