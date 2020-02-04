'use strict';
/*
 * Server code
 */
const uuid = require('uuid/v1');

const users = {};
const clients = {};
const server = {};

function initio(httpServer, db, chatbot) {

  const io = require('socket.io')(httpServer);
  io.on('connection', client => {
    client.on('echo', obj => {
      client.emit('echo', 'id: '+client.id+' send back from server>>> '+obj.msg);
    })
    client.emit('data', 'Hello everybody');
  })

  server['io'] = io;
  server['db'] = db;
  server['chatbot'] = chatbot;
}


exports.initio = module.exports.initio = initio;

/*
 * Client code
 */
// on ready
/*
$(function() {
  console.log('>>>onReady');
  let socket = io('http://localhost:19006');

  socket.on('connect', () => {
    console.log('init connect to server');
    socket.emit('test', {msg:'msg from video wall'});
  })
  socket.on('data', msg => {
    console.log('msg: ', msg);
  })
});
*/
