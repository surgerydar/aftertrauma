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
        //
        // admin
        //
        app.get('/admin', function (req, res) {
            res.render('admin', {title:'AfterTrauma Admin'});
        });
        app.get('/admin/:category', function (req, res) {
            var category = req.params.category;
            db.find( 'content', { category: category }, { title: 1 } ).then( function( response ) {
                res.render('category', {title:'AfterTrauma > ' + ( category && category.charAt(0).toUpperCase() + category.slice(1) ), category: category, items: response });
            }).catch( function( error ) {
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
            
        });
        app.post('/admin/:category', jsonParser, function (req, res) { // new item
            var category    = req.params.category;
            var item        = req.body;
            item.date       = Date.now();
            item.category   = category;
            item.blocks     = item.blocks || [];
            db.insert( 'content',  item ).then( function( response ) {
                res.json({ status: 'OK', response: response, item: item });
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.put('/admin/:category/:item', jsonParser, function (req, res) { // update item
            var category    = req.params.category;
            var item        = req.body;
            item.date       = Date.now();
            item.category   = category;
            var id          = db.ObjectId(req.params.item);
            db.updateOne( 'content',  { _id: id }, item ).then( function( response ) {
                res.json({ status: 'OK', response: response});
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.delete('/admin/:category/:item', function (req, res) {
            var category    = req.params.category;
            var id          = db.ObjectId(req.params.item);
            db.remove( 'content', { _id: id } ).then( function( response ) {
                res.json({ status: 'OK', response: response});
             }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
            
        });
        app.get('/admin/:category/:item', function (req, res) {
            var category    = req.params.category;
            var id          = db.ObjectId(req.params.item);
            db.findOne( 'content', { _id: id } ).then( function( response ) {
                res.render('item', {title:'AfterTrauma > ' + capitalise(category) + ' > ' + response.title, category: category, itemTitle: response.title, item: response._id, blocks: response.blocks || [] });
            }).catch( function( error ) {
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
            
        });
        app.get('/admin/:category/:item/:block', function (req, res) {
            var category    = req.params.category;
            var id          = db.ObjectId(req.params.item);
            var blockIndex  = parseInt(req.params.block);
            var type        = req.query.type;
            db.findOne( 'content', { _id: id } ).then( function( response ) {
                var block = blockIndex >= 0 && blockIndex < response.blocks.length ? response.blocks[ blockIndex ] : {type: type, title:"", content:"", tags:[]};
                res.render('block', {title:'AfterTrauma > ' + capitalise(category) + ' > ' + response.title, category: category, item: id, index: blockIndex, block: block} );
            }).catch( function( error ) {
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
        });
        app.put('/admin/:category/:item/:block', jsonParser, function (req, res) { // update item
            var category    = req.params.category;
            var id          = db.ObjectId(req.params.item);
            var blockIndex  = parseInt(req.params.block);
            var block       = req.body; 
            var operation;
            if ( blockIndex < 0 ) {
                operation = {
                    $push: {
                        blocks : block
                    },
                    $set: {
                        date : Date.now()
                    }
                };
            } else {
                operation = { 
                    $set: {}, 
                    $set: {
                        date : Date.now()
                    } 
                };
                operation[ '$set' ][ 'blocks.' + blockIndex ] = block;
            }
            db.updateOne( 'content',  { _id: id }, operation ).then( function( response ) {
                res.json({ status: 'OK', response: response});
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.delete('/admin/:category/:item/:block', function (req, res) { // delete block
            var category    = req.params.category;
            var id          = db.ObjectId(req.params.item);
            var blockIndex  = parseInt(req.params.block);
            var operation   = { $unset: { } };
            operation['$unset'][ 'blocks.' + blockIndex ] = null;
            db.updateOne( 'content',  { _id: id }, operation ).then( function( response ) {
                db.updateOne( 'content',  { _id: id }, { $pull: { blocks: null }, $set: { date: Date.now() } } ).then( function( response ) {
                    res.json({ status: 'OK', response: response});
                }).catch( function( error ) {
                    res.json({ status: 'ERROR', error: error});
                });
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
       //
        //
        //
        function capitalise( word ) {
            return word && word.charAt(0).toUpperCase() + word.slice(1);
        }
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
