'use strict';

const { parentPort, workerData } = require('worker_threads');
const { createCanvas, loadImage, registerFont } = require('canvas');
const fs = require('fs');
const path = require('path');

const OUTPUT_WIDTH = 1200;
const OUTPUT_HEIGHT = 630;

registerFont(fontFile('OpenSans-Regular.ttf'), { family: 'OpenSans' });
registerFont(fontFile('NotoSansTC-Regular.otf'), { family: 'NotoSansTC' });

async function textOverImage(text, save, color="FFFF00", fileName="fb_share_1") {
  const img = './public/images/'+fileName+'.png';
  const mycanvas = createCanvas(OUTPUT_WIDTH, OUTPUT_HEIGHT);
  const gifctx = mycanvas.getContext('2d');
  const image = await loadImage(img);
  gifctx.drawImage(image, 0, 0, OUTPUT_WIDTH, OUTPUT_HEIGHT);
  gifctx.font = '50px OpenSans';
  gifctx.fillStyle = "#00FF00";
  gifctx.fillText('0123456789abcdefg', 650, 230);
  gifctx.font = '80px NotoSansTC';
  gifctx.fillStyle = "#"+color;
  gifctx.fillText(text, 80, 370);
  saveImg('png', save, mycanvas);
  parentPort.postMessage(save);
}

function saveImg(type, save, mycanvas) {
  let fn = './public/upload/'+save+'.png';
  if (type=='png') {
    const out = fs.createWriteStream(fn);
    const stream = mycanvas.createPNGStream();
    stream.pipe(out);
  }
  if (type=='jpg') {
    fn = './public/upload/'+save+'.jpg';
    const out = fs.createWriteStream(fn);
    const stream = mycanvas.createJPEGStream();
    stream.pipe(out);
  }
}

function fontFile(name) {
  return path.join(__dirname, '/../fonts/', name)
}

textOverImage(workerData.txt, workerData.fn);

