# -*- coding: utf-8 -*-
#
# Copyright 2020 isobar. All Rights Reserved.
#
# Usage:
#       python text-over-img.py 80 370 'test-新年快樂' ./public/images/fb_share_1.png ./public/images/output.png
#

import os
import sys
from PIL import Image, ImageDraw, ImageFont


font80 = ImageFont.truetype('/app/public/fonts/NotoSansTC-Regular.otf', size=80)
#font50 = ImageFont.truetype('/app/public/fonts/NotoSansTC-Regular.otf', size=50)

pos_x = int(sys.argv[1])
pos_y = int(sys.argv[2])
txt = sys.argv[3]
src = sys.argv[4]
out = sys.argv[5]

im = Image.open(src)
draw = ImageDraw.Draw(im)
draw.text((pos_x, pos_y), txt, "#AAFFAA", font=font80)
im.save(out)

