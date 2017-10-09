ffmpeg -i $INPUT [-loop 10 -final_delay 500] $OUTPUT.gif
# https://ffmpeg.org/ffmpeg-formats.html#gif-2

ffmpeg -i $INPUT -filter_complex loop=$LOOPS:$FR_SIZE:$FR_START $OUTPUT
# https://ffmpeg.org/ffmpeg-filters.html#loop


ffmpeg -t $DURATION -r $FR_RATE -f avfoundation -i "default" $OUTPUT.mpg
# https://trac.ffmpeg.org/wiki/Capture/Webcam#OSX

ffmpeg -i $INPUT.mov -i $INPUT2.mp4 -filter_complex "[0]colorkey=color=$COLOR_KEY:similarity=$SIML[keyed];[1][keyed]overlay" $OUTPUT
# https://ffmpeg.org/ffmpeg-filters.html#colorkey

