const socket = new WebSocket('ws://'+location.host);
socket.addEventListener('open', function (event) {
    socket.send('Hello Server!');
});

socket.addEventListener('message', function (event) {
    console.log('Message from server ', event.data);
});

socket.addEventListener('close', function() {
    console.log('Close');
});
