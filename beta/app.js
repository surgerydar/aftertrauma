var env = process.env;
var config = require('./config');
var fs = require('fs');
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
).then( function( db_connection ) {
    try {
        //
        // configure express
        //
        console.log('initialising express');
        let express = require('express');
        let bodyParser = require('body-parser');
        let jsonParser = bodyParser.json();
        let mailer = require('./mailer.js');
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
        app.get('/avatar/:id', function (req, res) {
            // update user
            db.findOne( 'users', { id: req.params.id }, { avatar: 1 } ).then( function( response ) {
                /*
  				let width = parseInt(req.query.width);
				let height = parseInt(req.query.height);
				let transform = sharp().resize(width, height).max();
				request(redirUrl).pipe(transform).pipe(res);              
                */
                //
                //
                //
                var img = new Buffer(response.avatar.split(',')[1], 'base64');
                res.writeHead(200, {
                    'Content-Type': 'image/png',
                    'Content-Length': img.length
                });
                res.end( img );
            } ).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
        });
        //
        // admin
        //
        let admin = require('./routes/admin')( pasportAuth, db );
        app.use( '/admin', admin );
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
        try { // TODO: roll out exception handling for all modules
            console.log('groupchat');
            let groupchat = require('./groupchat');
            groupchat.setup(wsr,db);
        } catch( error ) {
            console.error('unable to install croup chat : ' + error );
        }
        //
        // connect day
        //
        console.log('day');
        let day = require('./day');
        day.setup(wsr,db);
        //
        // connect sync
        //
        console.log('sync');
        let sync = require('./sync');
        sync.setup(wsr,db);
        //
        // connect fileuploader
        //
        let fileuploader = require('./fileuploader');
        fileuploader.setup(wsr);
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
        server.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', () => console.log('Server started'));
    } catch( error ) {
        console.log( 'unable to start server : ' + error );
    }
}).catch( function( err ) {
	console.log( 'unable to connect to database : ' + err );
});
