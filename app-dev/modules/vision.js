'use strict';

const { createCanvas, loadImage, registerFont } = require('canvas');
//const GIFEncoder = require('gifencoder');
const fs = require('fs');

const OUTPUT_WIDTH = 1200;
const OUTPUT_HEIGHT = 630;

//registerFont('./fonts/OpenSans-Regular.ttf', { family: 'OpenSans' });
registerFont('./fonts/NotoSansTC-Regular.otf', { family: 'NotoSansTC' });

const mycanvas = createCanvas(OUTPUT_WIDTH, OUTPUT_HEIGHT);
const gifctx = mycanvas.getContext('2d');

function textOverImage(text, save, color="FFFF00", fileName="fb_share_1") {
  const img = './public/images/'+fileName+'.png';
  loadImage(img)
    .then((image) => {
//      const image = await loadImage(img);
      const mycanvas = createCanvas(OUTPUT_WIDTH, OUTPUT_HEIGHT);
      const gifctx = mycanvas.getContext('2d');
      gifctx.drawImage(image, 0, 0, OUTPUT_WIDTH, OUTPUT_HEIGHT);
      //gifctx.font = '30px Arial,"AR PL UMing TW"';
      //gifctx.font = '50px OpenSans';
      gifctx.font = '50px NotoSansTC';
      gifctx.fillStyle = "#00FF00";
      gifctx.fillText('0123456789abcdefg', 650, 230);
      gifctx.font = '80px NotoSansTC';
      gifctx.fillStyle = "#"+color;
      gifctx.fillText(text, 80, 370);
      saveImg('png', save, mycanvas);
      //saveImg('jpg', save, mycanvas);
    }) 
    .catch(err => {})
}

function generateGif(fn="demo") {
  const arr = ['./public/images/fb_share_1.png', './public/images/fb_share_2.png', './public/images/fb_share_3.png', './public/upload/demo.png'];
  const encoder = new GIFEncoder(OUTPUT_WIDTH, OUTPUT_HEIGHT);
  encoder.createReadStream().pipe(fs.createWriteStream('./public/upload/'+fn+'.gif'))
  encoder.start();
  encoder.setRepeat(0);
  encoder.setDelay(500);
  encoder.setQuality(10);
  for (let img of arr) {
    loadImage(img)
      .then((image) => {
//        const image = await loadImage(img);
        gifctx.drawImage(image, 0, 0, OUTPUT_WIDTH, OUTPUT_HEIGHT);
        encoder.addFrame(gifctx);
        if (img === arr[arr.length-1]) {
          encoder.finish();
          console.log('GIF encoder finish');
        }
      })
      .catch(err => {})
  }
}

function saveImg(type, save, mycanvas) {
  let fn = './public/upload/'+save+'.png';
  if (type=='png') {
    const out = fs.createWriteStream(fn);
    const stream = mycanvas.createPNGStream({compressionLevel: 1});
    stream.pipe(out);
  }
  if (type=='jpg') {
    fn = './public/upload/'+save+'.jpg';
    const out = fs.createWriteStream(fn);
    const stream = mycanvas.createJPEGStream();
    stream.pipe(out);
  }
}

//textOverImage(workerData.txt, workerData.fn);

exports.textOverImage = module.exports.textOverImage = textOverImage;
//exports.generateGif = module.exports.generateGif = generateGif;
