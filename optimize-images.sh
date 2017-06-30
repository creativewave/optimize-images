#!/bin/bash

if [ -z $1 ]
then
    echo "Missing argument for directory path."
    exit 1
elif [ ! -e $1 ]
then
    echo "$1 doesn't exists."
    exit 1
elif [ ! -d $1 ]
then
    echo "$1 is not a directory."
    exit 1
fi

find $1 -type f -iregex '.*\.\(jpe?g\|png\)' -mmin -1400 |
    xargs mogrify                          `# http://www.imagemagick.org/script/command-line-options.php` \
        -strip                             `# Remove ICC profile (prefer presuming sRGB) and meta data.` \
        -filter Triangle                   `# Use bilinear interpolation as resampling method.` \
        -define filter:support=2           `# Use 2x2 pixels filter support area.` \
        -thumbnail 1920x1080\>             `# Resize in full HD (if wider/taller, preserves aspect ratio).` \
        -quality 82                        `# Equivalent to quality 60 with 'Save for Web' in Photoshop.` \
        `#+dither                           # Prevent automatic noise addition after posterization.` \
        `#-posterize 128                    # Reduce (by half) color levels per (RVB) channel.` \
        -unsharp 0.25x0.08+8.3+0.045       `# Sharpen to counterbalance blur from down sizing.` \
        -define jpeg:fancy-upsampling=off  `# Prevent automatic inefficient sampling.` \
        -define png:compression-filter=5   `# Use adaptive filtering.` \
        -define png:compression-level=9    `# Highest quality, slowest processing.` \
        -define png:compression-strategy=1 `# Default strategy.` \
        -define png:exclude-chunk=all      `# Remove PNG specific meta data.` \
        -interlace Plane                   `# Interlace for progressive rendering (vs. sequential).` \
        `#-colorspace sRGB                  # Convert colors to sRGB (W3C spec).`

echo "End of optimization."
