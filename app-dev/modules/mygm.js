'use strict';

const fs = require('fs');
const gm = require('gm');

const OUTPUT_WIDTH = 1200;
const OUTPUT_HEIGHT = 630;

const font1 = './fonts/NotoSansTC-Regular.otf';
const font2 = './fonts/OpenSans-Regular.ttf';

function textOverImage(text, save, color="FFFF00", fileName="fb_share_1.png", qual=75) {
  const imgExt = fileName.substr(fileName.length-3)
  const img = './public/images/'+fileName;
  const out = './public/upload/'+save+'.'+imgExt;
  const q = imgExt=='png' ? 10 : qual;
  return new Promise((resolve, reject) => {
    gm(img)
      .font(font1)
      .fontSize(50)
      .fill("#00FF00")
      .drawText(650,230,'0123456789一二三四五')
      .font(font1)
      .fontSize(80).fill('#'+color)
      .drawText(80,370,text)
      .quality(q)
      .write(out, (err)=>{
        resolve();
        //if(err) console.log(err);
      })
  })
}


exports.textOverImage = module.exports.textOverImage = textOverImage;
