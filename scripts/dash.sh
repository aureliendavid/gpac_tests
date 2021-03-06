#!/bin/sh

test_begin "dash-basic"

do_test "$MP4BOX -add $EXTERNAL_MEDIA_DIR/counter/counter_30s_I25_baseline_1280x720_512kbps.264 -add $EXTERNAL_MEDIA_DIR/counter/counter_30s_audio.aac -new $TEMP_DIR/file.mp4" "input-preparation"
do_hash_test "$TEMP_DIR/file.mp4" "input-preparation"


if [ -f "$TEMP_DIR/file.mpd" ] ; then
	rm "$TEMP_DIR/file.mpd"
fi

do_test "$MP4BOX -dash 1000 -rap $TEMP_DIR/file.mp4#video $TEMP_DIR/file.mp4#audio -out $TEMP_DIR/file.mpd" "mpd"

do_hash_test "$TEMP_DIR/file.mpd" "mpd"
do_hash_test "$TEMP_DIR/file_dash_track1_init.mp4" "segment-video"
do_hash_test "$TEMP_DIR/file_dash_track2_init.mp4" "segment-audio"

myinspect=$TEMP_DIR/inspect.txt
do_test "$GPAC -i $TEMP_DIR/file.mpd inspect:allp:deep:interleave=false:log=$myinspect"
do_hash_test $myinspect "inspect"

test_end
