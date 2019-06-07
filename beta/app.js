/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
var env = process.env;
const config = require('./config');
//var fs = require('fs');
const sharp = require('sharp');
//
// connect to database
//
var db = require('./aftertrauma.db.js');
db.connect(
	env.MONGODB_DB_HOST,
	env.MONGODB_DB_PORT,
	env.APP_NAME,
    env.MONGODB_DB_USERNAME,
	env.MONGODB_DB_PASSWORD
).then( () => {
    try {
        //
        // configure express
        //
        console.log('initialising express');
        const express = require('express');
        const bodyParser = require('body-parser');
        //const jsonParser = bodyParser.json();
        //const mailer = require('./mailer.js');
        //
        //
        //		
        let app = express();
        //
        //
        //
        app.use(bodyParser.json( {limit:'5mb'} ));
        app.use(bodyParser.urlencoded({'limit': '5mb', 'extended': false }));
        //
        // configure express
        //
        app.set('view engine', 'pug');
        app.use(express.static(__dirname+'/static',{dotfiles:'allow'}));
        let pasportAuth = require('./passportauth')( app, db );
        //
        // express routes
        //
        console.log('express routes');
        app.get('/', function (req, res) {
            res.json({ status: 'ok' });
        });
        //
        // user
        //
        app.get('/avatar/:id', (req, res)=>{
            // update user
            db.findOne( 'users', { id: req.params.id }, { avatar: 1 } ).then( function( response ) {
                if ( req.query.width && req.query.height ) {
                    let buffer = new Buffer(response.avatar.split(',')[1], 'base64');
                    let width = parseInt(req.query.width);
                    let height = parseInt(req.query.height);
                    let transform = sharp(buffer).resize(width, height).max();
                    res.writeHead(200, {
                        'Content-Type': 'image/png'
                    });
                    transform.pipe(res);  
                } else {
                    //
                    //
                    //
                    let img = new Buffer(response.avatar.split(',')[1], 'base64');
                    res.writeHead(200, {
                        'Content-Type': 'image/png',
                        'Content-Length': img.length
                    });
                    res.end( img );
                }
            } ).catch( ( error )=>{
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
        });
        //
        // admin
        //
        let adminRoutes = require('./routes/admin')( pasportAuth, db );
        app.use( '/admin', adminRoutes );
        //
        // usage
        //
        let usageRoutes = require('./routes/usage')( pasportAuth, db );
        app.use( '/usage', usageRoutes );
        /*
        //
        // remove these in production
        //
        app.get('/testemail/:message', function(req,res) {
            mailer.send( 'jons@soda.co.uk', 'Testing AfterTrauma', req.params.message ).then( function( response ) {
                res.json( {status: 'OK'} );
            }).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
        });
        */
        //
        // configure websockets
        //
        console.log('configuring websocket router');
        let wsr = require('./websocketrouter');
        //
        // connect validator
        //
        console.log('validator');
        let validator = require('./validator');
        validator.setup(wsr,db);
        //
        // connect authentication
        //
        console.log('authentication');
        let authentication = require('./authentication');
        authentication.setup(wsr,db);
        //
        // connect profile
        //
        console.log('profile');
        let profile = require('./profile');
        profile.setup(wsr,db);
        //
        // connect chat
        //
        /*
        console.log('chat');
        let chat = require('./chat');
        chat.setup(wsr,db);
        */
        //
        // connect groupchat
        //
        try { 
            console.log('groupchat');
            let groupchat = require('./groupchat');
            groupchat.setup(wsr,db);
        } catch( error ) {
            console.error('unable to install group chat : ' + error );
        }
        //
        // connect day
        //
        try { 
            console.log('day');
            let day = require('./day');
            day.setup(wsr,db);
        } catch( error ) {
            console.error('unable to install day : ' + error );
        }
        //
        // connect sync
        //
        try {
            console.log('sync');
            let sync = require('./sync');
            sync.setup(wsr,db);
        } catch( error ) {
            console.error('unable to install sync : ' + error );
        }
        //
        // connect fileuploader
        //
        try {
            let fileuploader = require('./fileuploader');
            fileuploader.setup(wsr);
        } catch( error ) {
            console.error('unable to install fileuploader : ' + error );
        }
        //
        // connect usage
        //
        try {
            console.log('usage');
            let usage = require('./usage');
            usage.setup(wsr,db);
        } catch( error ) {
            console.error('unable to install fileuploader : ' + error );
        }
        //
        // create server
        //
        console.log('creating server');
        let httpx = require('./httpx');
        let server = httpx.createServer(config.ssl, { http:app, ws:wsr });
        //
        // start listening
        //
        console.log('starting server');
        server.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', () => {
            console.log('Server started')
        });
        //
        //
        //
    } ( error ) => {
        console.log( 'unable to start server : ' + error );
    }
}).catch( ( error ) => {
	console.log( 'unable to connect to database : ' + error );
});
