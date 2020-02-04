// on ready
$(function() {
  console.log('>>>onReady');
  // let socket = io('https://0ee5dff1.ngrok.io');
  // let socket = io('http://localhost:19006');
  // force socketio only use websocket
  // http://localhost:8000/iotest.html?ws=1
  const ws = getSearchParams('ws');
  const ts = ws=='1' ? ['websocket'] : ['polling', 'websocket'];
  let socket = io('http://'+window.location.host, {transports:ts});

  socket.on('connect', () => {
    console.log('init connect to server:');
    addLog('init connet to server');
    console.time('loop');
    socket.emit('echo', {msg:'Hello Server'});
    sid = setInterval(loopSend, 30000);
  })

  socket.on('disconnect', () => {
    console.log('disconnect');
    addLog('disconnect');
  })

  socket.on('data', msg => {
    console.log('msg: ', msg);
    addLog(msg);
  })

  socket.on('echo', msg => {
    console.timeEnd('loop');
    addLog(msg);
    console.log('echo msg: ', msg);
  })

  socket.on('all.msgs', arr => {
    console.log('arr:',arr);
    if (!arr) {
      return
    }
    for (let s of arr) {
      console.log(s);
    }
  })

  socket.on('show1', psid => {
    console.log('left qrcode: ', psid);
  })
  
  socket.on('show2', psid => {
    console.log('mid qrcode: ', psid);
  })
  
  socket.on('show3', psid => {
    console.log('right qrcode: ', psid);
  })

  socket.on('msg', msg => {
    console.log('msg: ', msg);
  })

  let sid;
  let cnt = 0;
  let end = 100;
  function loopSend() {
    if (cnt>end) {
      clearInterval(sid);
      return;
    }
    console.time('loop');
    socket.emit('echo', {msg:'loop'+cnt++});
  }

  function addDate() {
    return '['+new Date().toLocaleString()+'] '
  }

  function getSearchParams(k){
    var p={};
    location.search.replace(/[?&]+([^=&]+)=([^&]*)/gi,function(s,k,v){p[k]=v})
    return k?p[k]:p;
  }

  //let elm = document.createElement('ol');
  //document.body.appendChild(elm);
  function addLog(m) {
    let i = document.createElement('li');
    i.innerText = '['+ new Date().toLocaleString() +'] '+m;
    document.getElementById('loglist').appendChild(i);
  }
});

