# -*- coding: utf-8 -*-
#
# Copyright 2020 isobar. All Rights Reserved.
#

import os
import sys
import uuid
from aiohttp import web
from aiojobs.aiohttp import setup, spawn
from PIL import Image, ImageDraw, ImageFont

font80 = ImageFont.truetype('/app/public/fonts/NotoSansTC-Regular.otf', size=80)

async def worker(uid, color, text):
    src = '/app/public/images/fb_share_1.png'
    out = '/app/public/upload/'+uid+'.png'
#    src = '/app/public/images/fb_share_1.jpg'
#    out = '/app/public/upload/'+uid+'.jpg'
    im = Image.open(src)
    draw = ImageDraw.Draw(im)
    draw.text((80, 370), text, '#'+color, font=font80)
    im.save(out, compress_level=1) # default 6
#    im.save(out)

async def handle(request):
    name = request.match_info.get('name', "Anonymous")
    text = "Hello, " + name
    return web.Response(text=text)

async def handleImg(request):
    uid = str(uuid.uuid4())
    color = request.match_info.get('color', "FF0000")
    text = request.match_info.get('text', "hello123")
    await spawn(request, worker(uid, color, text))
    return web.Response(text='color {} text {} fn {}'.format(color,text,uid+'.png'))

async def web_app():
    app = web.Application()
    app.add_routes([web.get('/', handle),web.get('/{name}',handle),web.static('/public','/app/public'),
                web.get('/png/{color}/{text}', handleImg)])
    setup(app)
    return app

if __name__ == '__main__':
    app = web.Application()
    app.add_routes([web.get('/', handle),web.get('/{name}',handle),web.static('/public','/app/public'),
                web.get('/png/{color}/{text}', handleImg)])
    setup(app)
    web.run_app(app, port=8000)

