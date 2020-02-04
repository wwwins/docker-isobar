/**
 * Copyright 2019-2020 isobar. All Rights Reserved.
 */

'use strict';

const dotenv = require('dotenv').config();
const express = require('express');
const expressFileUpload = require("express-fileupload");
const https = require('https');
const http = require('http');
const fs = require('fs');
const bodyParser = require('body-parser');
const uuid = require('uuid');
const request = require('request-promise');
const JSONbig = require('json-bigint');
const async = require('async');
//const { Worker, workerData } = require('worker_threads');
const ENABLE_WORKER = false;
const nodeinfo = require('nodejs-info');
//const vision = require('../modules/vision');
const mygm = require('../modules/mygm');
const expressMongodb = require('express-mongo-db');
const _ = require('lodash');

const URL = process.env.URL;
const PORT = (process.env.PORT || 8000);
const HTTPS_PORT = (process.env.HTTPS_PORT || 443);
const EXT_IP = process.env.EXT_IP
const ENABLE_SSL = process.env.ENABLE_SSL=='true' ? true : false;
const API_HOST = (ENABLE_SSL=='true' ? 'https://' : 'http://')+EXT_IP+':'+PORT+'/'
const MONGO_URI = process.env.MONGO_URI;
const ENABLE_MONGO = MONGO_URI!="";
const JPG_QUALITY = (process.env.JPG_QUALITY || 75);

const DEBUG = true;


const app = express();

app.set('view engine', 'pug');

app.use(express.static('public'));
app.use(bodyParser.text({type: 'application/json'}));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(expressFileUpload())
if (ENABLE_MONGO)
  app.use(expressMongodb(MONGO_URI));


app.get('/', (req, res) => {
    res.render('index', { redirect_uri: req.query['redirect_uri'], authorization_code: req.query['authorization_code'] })
})

// ---------- nodejs info ----------
app.get('/info', (req, res) => {
    res.send(nodeinfo(req));
});
// ---------- end ----------

// ---------- crash it ----------
app.get('/crash', (req, res) => {
    process.exit(1);
});
// ---------- end ----------

// ---------- mongo ----------
// your.host.name/mongo/info
app.get('/mongo/info', (req, res) => {
  req.db.admin().serverInfo((err, result) => {
    res.json(result);
  });
});

// your.host.name/mongo/hello/test
app.get('/mongo/hello/:c', (req, res) => {
  const cName = req.params.c;
  if (cName) {
    req.db.collection(cName).find().count().then(r => {
      res.send('success:'+r);
    });
  }
  else {
    res.send('failure');
  }
});

// your.host.name/mongo/update/test
app.get('/mongo/update/:c', (req, res) => {
  const cName = req.params.c;
  if (cName) {
    const uid = uuid();
    req.db.collection(cName).update({id:uid}, {id:uid, date:Date().toString(), time:Date.now()}, {upsert:true}).then(r => {
      res.send('success:'+uid);
    });
  }
  else {
    res.send('failure');
  }
});

// your.host.name/mongo/delete/test/del-uid
app.get('/mongo/delete/:c/:uid', (req, res) => {
  const cName = req.params.c;
  const uid = req.params.uid;
  if (cName) {
    req.db.collection(cName).deleteOne({id:uid}).then(r => {
      res.send('success:'+r);
    });
  }
  else {
    res.send('failure');
  }
});

// your.host.name/mongo/remove/test
app.get('/mongo/remove/:c', (req, res) => {
  const cName = req.params.c;
  const uid = req.params.uid;
  if (cName) {
    req.db.collection(cName).remove({});
  }
  res.send('success');
});

// ---------- end ----------

// ---------- gm ----------
// your.host.name/png/EEFF00/test1234567890
app.get('/png/:color/:text', async (req, res) => {
  try {
    const text = req.params.text;
    const color = req.params.color;
    const uid = uuid();
    if (text) {
      await mygm.textOverImage(text, uid, color, 'fb_share_1.png');
      await res.json({success:true, png:URL+'/upload/'+uid+'.png', jpg:URL+'/upload/'+uid+'.jpg'});
    }
  }
  catch (error) {
    return next(error);
  }
});

// your.host.name/png/EEFF00/test1234567890
app.get('/jpg/:color/:text', async (req, res) => {
  try {
    const text = req.params.text;
    const color = req.params.color;
    const uid = uuid();
    const qual = Number(JPG_QUALITY);
    if (text) {
      await mygm.textOverImage(text, uid, color, 'fb_share_1.jpg', qual);
      await res.json({success:true, png:URL+'/upload/'+uid+'.png', jpg:URL+'/upload/'+uid+'.jpg'});
    }
  }
  catch (error) {
    return next(error);
  }
});
// ---------- end ----------

// ---------- canvas ----------
// your.host.name/img/EEFF00/test1234567890
app.get('/img/:color/:text', async (req, res) => {
  try {
    const text = req.params.text;
    const color = req.params.color;
    const uid = uuid();
    if (text) {
//      await vision.textOverImage(text, uid, color, 'fb_share_1');
//      await res.json({success:true, png:URL+'/upload/'+uid+'.png', jpg:URL+'/upload/'+uid+'.jpg'});
    }
  }
  catch (error) {
    return next(error);
  }
});

// worker multi thread
app.get('/timg/:color/:text', async (req, res) => {
  try {
    const text = req.params.text;
    const color = req.params.color;
    const uid = uuid();
    const data = {txt:text, fn:uid};
    if (text) {
//      const worker1 = new Worker('./modules/text-over-image.js', { workerData: data });
//      worker1.on("message", (msg) => {
//        console.log(msg);
//        res.json({success:true, file:msg});
//      });
    }
  }
  catch (error) {
    return next(error);
  }
});

// ---------- end ----------

// ---------- websocket ----------
// https://github.com/websockets/ws
app.get('/websocket/', (req, res) => {
    res.render('websocket');
});
// ---------- end ----------

// ---------- file upload ----------
app.get('/uploader/', (req, res) => {
    res.render('uploader');
})

app.post('/upload/', (req, res) => {
    if (!req.files) {
        res.status(400).send("No file was uploaded.");
    }
    let file = req.files.filename;
    //let filename = req.files.filename.name.replace(/[\/\?<>\\:\*\|":]/g, '').toLowerCase();
    const filename = uuid()+'.jpg';
    file.mv('public/upload/'+filename, (err) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.json({"url":URL+'/upload/'+filename})
    })
})
// ---------- end ----------

const server = http.createServer(app);
server.listen(PORT, () => {
    console.log('Rest service ready on port ' + PORT); 
});

