#!/bin/sh

# shorten -v/h photo_image from_positon to_positon destination

# This program takes one image and cut out the region between **from_positon**
# and **to_positon** in percent, so we can focus on what really matters. In
# other words, it **shortens** your too long/wide images in middle.
# [ImageMagick](http://www.imagemagick.org) is required to run this script.

# OPTIONS

#    -v Shorten the image in vertical direction.
#    -h Shorten the image in horizontal direction.

# ashfinal@gmail.com    2018-02-26

PROGNAME=$(basename $0)

Usage() {
    cat <<EOF
Usage: $PROGNAME -v/h photo_image from_positon(%) to_positon(%) destination

Options:
    -v Shorten the image in vertical direction.
    -h Shorten the image in horizontal direction.

Example:
    $PROGNAME -v long_image.png 20 60 short_image.png
EOF
    exit 10
}

# Read in commandline options
if [ $# -eq 0 ]; then
    Usage
elif [ $# -eq 1 ]; then
    case "$1" in
        --help|-h) Usage ;;
        *)  echo "Unknown option \"$1\"" && Usage ;;
    esac
elif [ $# -eq 5 ]; then
    case "$1" in
        -v)  GRAVITY=("northwest" "northeast" "southwest" "southeast") ;;
        -h)  GRAVITY=("northwest" "southwest" "northeast" "southeast") ;;
        *)  echo "Unknown option \"$1\"" && Usage ;;
    esac
else
    echo "Wrong arguments number." && Usage
fi

# Temporary working images (with auto-clean-up on exit)
tmp1=`mktemp /tmp/${PROGNAME}.1.XXXXXX` || exit 1
tmp2=`mktemp /tmp/${PROGNAME}.2.XXXXXX` || exit 1
tmp3=`mktemp /tmp/${PROGNAME}.3.XXXXXX` || exit 1
tmp4=`mktemp /tmp/${PROGNAME}.4.XXXXXX` || exit 1

tmp5=`mktemp /tmp/${PROGNAME}.5.XXXXXX` || exit 1
tmp6=`mktemp /tmp/${PROGNAME}.6.XXXXXX` || exit 1
tmp7=`mktemp /tmp/${PROGNAME}.7.XXXXXX` || exit 1
tmp8=`mktemp /tmp/${PROGNAME}.8.XXXXXX` || exit 1
trap "rm -f $tmp1 $tmp2 $tmp3 $tmp4 $tmp5 $tmp6 $tmp7 $tmp8" 0
trap "exit 2" 1 2 3 15

if [ $1 == '-v' ]; then
    CANVAS_LEN=`identify -format '%h' $2` # Image height
    FROM_POS=`expr $CANVAS_LEN \* $3 / 100`
    TO_POS=`expr $CANVAS_LEN \* $4 / 100`
    convert $2 -crop x${FROM_POS}+0+0 miff:$tmp1 # The first half
    convert $tmp1 -gravity ${GRAVITY[0]} -splice 80x40+0+0 -gravity \
        ${GRAVITY[1]} -splice 80x40+0+0 \( +clone -alpha extract \
        -virtual-pixel black -spread 160 -blur 0x3 -threshold 50% \
        -spread 1 -blur 0x.7 \) -alpha off -compose copy_opacity \
        -composite miff:$tmp2 # Add torn paper edge
    convert $tmp2 -gravity ${GRAVITY[0]} -chop 80x40 -gravity \
        ${GRAVITY[1]} -chop 80x40 miff:$tmp3 # Trim the extra region
    convert $tmp3 \( +clone -background grey -shadow 60x0+0+4 \) +swap \
        -background none -layers merge +repage miff:$tmp4 # Add shadow
    convert $2 -crop +0+$TO_POS miff:$tmp5 # The second half
    convert $tmp5 -gravity ${GRAVITY[2]} -splice 80x40+0+0 -gravity \
        ${GRAVITY[3]} -splice 80x40+0+0 \( +clone -alpha extract \
        -virtual-pixel black -spread 160 -blur 0x3 -threshold 50% \
        -spread 1 -blur 0x.7 \) -alpha off -compose copy_opacity \
        -composite miff:$tmp6 # Add torn paper edge
    convert $tmp6 -gravity ${GRAVITY[2]} -chop 80x40 -gravity \
        ${GRAVITY[3]} -chop 80x40 miff:$tmp7 # Trim the extra region
    convert $tmp7 \( +clone -background grey -shadow 60x0+0+4 \) +swap \
        -background none -layers merge +repage miff:$tmp8 # Add shadow
    convert $tmp4 $tmp8 -append $5 # Stitch the two half
else
    CANVAS_LEN=`identify -format '%w' $2` # Image width
    FROM_POS=`expr $CANVAS_LEN \* $3 / 100`
    TO_POS=`expr $CANVAS_LEN \* $4 / 100`
    convert $2 -crop ${FROM_POS}x+0+0 miff:$tmp1 # The first half
    convert $tmp1 -gravity ${GRAVITY[0]} -splice 40x80+0+0 -gravity \
        ${GRAVITY[1]} -splice 40x80+0+0 \( +clone -alpha extract \
        -virtual-pixel black -spread 160 -blur 0x3 -threshold 50% \
        -spread 1 -blur 0x.7 \) -alpha off -compose copy_opacity \
        -composite miff:$tmp2 # Add torn paper edge
    convert $tmp2 -gravity ${GRAVITY[0]} -chop 40x80 -gravity \
        ${GRAVITY[1]} -chop 40x80 miff:$tmp3 # Trim the extra region
    convert $tmp3 \( +clone -background grey -shadow 60x0+4+0 \) +swap \
        -background none -layers merge +repage miff:$tmp4 # Add shadow
    convert $2 -crop +$TO_POS+0 miff:$tmp5 # The second half
    convert $tmp5 -gravity ${GRAVITY[2]} -splice 40x80+0+0 -gravity \
        ${GRAVITY[3]} -splice 40x80+0+0 \( +clone -alpha extract \
        -virtual-pixel black -spread 160 -blur 0x3 -threshold 50% \
        -spread 1 -blur 0x.7 \) -alpha off -compose copy_opacity \
        -composite miff:$tmp6 # Add torn paper edge
    convert $tmp6 -gravity ${GRAVITY[2]} -chop 40x80 -gravity \
        ${GRAVITY[3]} -chop 40x80 miff:$tmp7 # Trim the extra region
    convert $tmp7 \( +clone -background grey -shadow 60x0+4+0 \) +swap \
        -background none -layers merge +repage miff:$tmp8 # Add shadow
    convert $tmp4 $tmp8 +append $5 # Stitch the two half
fi
