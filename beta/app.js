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
        bodyParser.json( {limit:'5mb'} );
        //
        // configure express
        //
        app.set('view engine', 'pug');
        app.use(express.static(__dirname+'/static',{dotfiles:'allow'}));
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
        /*
        app.post('/user', jsonParser, function (req, res) {
            // create new user
            console.log( 'user : ' + JSON.stringify(req.body) );
            db.putUser( req.body ).then( function( response ) {
                res.json( {status: 'OK'} );
            } ).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
        });
        app.put('/user/:id', jsonParser, function (req, res) {
            // update user
            db.updateUser( req.params.id, req.body ).then( function( response ) {
                //
                //
                //
                res.json( {status: 'OK'} );
            } ).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
        });
        app.get('/user/byid/:id', function(req, res) {
            // get single user
            db.getUser(req.params.id).then( function( response ) {
                console.log( '/user/byid/' + req.params.id + ' : ' + JSON.stringify(response) );
                res.json( formatResponse( response, 'OK' ) );
            }).catch( function( error ) {
                res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
            });
        });
        app.get('/user/byemail/:email', function(req, res) {
            // get single user
            db.getUserByEmail(req.params.email).then( function( response ) {
                console.log( '/user/byemail/' + req.params.email + ' : ' + JSON.stringify(response) );
                if ( response ) {
                    res.json( formatResponse( response, 'OK' ) );
                } else {
                    res.json( formatResponse( null, 'ERROR', "Unknown user" ) );
                }
            }).catch( function( error ) {
                res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
            });
        });
        app.get('/user/byname/:name', function(req, res) {
            // get single user
            db.getUserByName(req.params.name).then( function( response ) {
                console.log( '/user/byname/' + req.params.name + ' : ' + JSON.stringify(response) );
                if ( response ) {
                    res.json( formatResponse( response, 'OK' ) );
                } else {
                    res.json( formatResponse( null, 'ERROR', "Unknown user" ) );
                }
            }).catch( function( error ) {
                res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
            });
        });
        app.delete('/user/:id', function(req, res) {
            // get single route
            db.deleteUser(req.params.id).then( function( response ) {
                res.json( formatResponse( response, 'OK' ) );
            }).catch( function( error ) {
                res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
            });
        });
        */
        //
        //
        //
        function formatResponse( data, status, message ) {
            var response = {};
            if ( message ) response[ 'message' ] = message;
            if ( status ) response[ 'status' ] = status;
            if ( data ) response[ 'data' ] = data;
            return response;
        }
        //
        // remove these in production
        //
        app.get('/drop/:collection', function(req, res) {
            // get single route
            db.drop(req.params.collection).then( function( response ) {
                res.json( {status: 'OK', data: response} );
            }).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
        });
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
        console.log('chat');
        let chat = require('./chat');
        chat.setup(wsr,db);
        //
        // connect day
        //
        console.log('day');
        let day = require('./day');
        day.setup(wsr,db);
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
