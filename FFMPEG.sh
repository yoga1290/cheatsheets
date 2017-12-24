ffmpeg -i $INPUT [-loop 10 -final_delay 500] $OUTPUT.gif
# https://ffmpeg.org/ffmpeg-formats.html#gif-2

ffmpeg -i $INPUT -filter_complex loop=$LOOPS:$FR_SIZE:$FR_START $OUTPUT
# https://ffmpeg.org/ffmpeg-filters.html#loop


ffmpeg -t $DURATION -r $FR_RATE -f avfoundation -i "default" $OUTPUT.mpg
# https://trac.ffmpeg.org/wiki/Capture/Webcam#OSX

# Scaling & Padding
# https://stackoverflow.com/a/8351875/1683797
scale="scale=\
  iw*min($width/iw\,$height/ih):ih*min($width/iw\,$height/ih),\
  pad=\
  $width:$height:($width-iw)/2:($height-ih)/2"
ffmpeg \
-y \
-i $INPUT \
-vf $scale \
$OUTPUT;

# Chroma-key (green screen effect):
# https://ffmpeg.org/ffmpeg-filters.html#colorkey
#COLOR_KEY='green'
#SIML=0.1
ffmpeg \
-i $INPUT \
-i $INPUT2 \
-filter_complex \
"[1] $scale[in1] ;\
[0] colorkey=color=$COLOR_KEY:similarity=$SIML [keyed];\
[in1][keyed]overlay" \
-y \
$OUTPUT
