/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
const net     = require('net');
const http    = require('http');
const https   = require('https');
const ws      = require('ws');

exports.createServer = (opts, routers)=>{
    //
    // create socket server
    //
    let server = net.createServer( (socket)=>{
        socket.once('data', (buffer)=>{
            // Pause the socket
            socket.pause();

            // Determine if this is an HTTP(s) request
            let byte = buffer[0];

            let protocol;
            if (byte === 22) {
                protocol = 'https';
            } else if (32 < byte && byte < 127) {
                protocol = 'http';
            }

            let proxy = server[protocol];
            if (proxy) {
                // Push the buffer back onto the front of the data stream
                socket.unshift(buffer);

                // Emit the socket to the HTTP(s) server
                proxy.emit('connection', socket);
            }
            
            // Resume the socket data stream
            socket.resume();
        });
    });
    //
    // create http + https servers
    //
    server.http = http.createServer(routers.http);
    server.https = https.createServer(opts,routers.http);
    //
    // create optional ws + wss servers
    //
    if ( routers.ws ) {
        server.ws = new ws.Server({server:server.http});
        server.ws.on('connection', (ws)=>{
            routers.ws.connection( server.ws, ws )
        });
        server.wss = new ws.Server({server:server.https});
        server.wss.on('connection', (ws)=>{
            routers.ws.connection( server.wss, ws )
        });
    }
    return server;
};
