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
        app.get('/admin/users', function (req, res) {
            res.render('category', {title:'AfterTrauma > Users', category: category, items: [] });           
        });
        app.get('/admin/:section', function (req, res) { // get section categories
            var section = req.params.section;
            db.find( 'category', { section: section }, { title: 1 } ).then( function( response ) {
                res.render('section', {title:'AfterTrauma > ' + capitalise( section ), section: section, categories: response });
            }).catch( function( error ) {
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
            
        });
        app.post('/admin/:section', jsonParser, function (req, res) { // new category
            var section         = req.params.section;
            var category        = req.body;
            category.date       = Date.now();
            category.section    = section;
            db.insert( 'category',  category ).then( function( response ) {
                res.json({ status: 'OK', response: response, category: category });
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.put('/admin/:section/:category', jsonParser, function (req, res) { // update category
            var category    = req.body;
            item.date       = Date.now();
            var _id         = db.ObjectId(req.params.category);
            db.updateOne( 'category',  { _id: _id }, category ).then( function( response ) {
                res.json({ status: 'OK', response: response});
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.delete('/admin/:section/:category', function (req, res) {
            var _id = db.ObjectId(req.params.category);
            db.remove( 'category', { _id: _id } ).then( function( response ) {
                res.json({ status: 'OK', response: response});
             }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
            
        });
        app.get('/admin/:section/:category', function (req, res) {
            var section = req.params.section;
            var _id = db.ObjectId(req.params.category);
            db.findOne( 'category', { _id: _id } ).then( function( category ) {
                db.find( 'document', { category: req.params.category } ).then( function( documents ) {
                    res.render('category', {title:'AfterTrauma > ' + category.title, section: category.section, category: category._id, documents: documents });
                }).catch( function( error ) {
                    //
                    // TODO: error
                    //
                    res.render('error', {title:'AfterTrauma Admin', error: error});
                });
            }).catch( function( error ) {
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
            
        });
        app.post('/admin/:section/:category', jsonParser, function (req, res) { // new document
            var section         = req.params.section;
            var category        = req.params.category;
            var document        = req.body;
            document.date       = Date.now();
            document.category   = category;
            document.blocks     = [];
            db.insert( 'document',  document ).then( function( response ) {
                res.json({ status: 'OK', response: response, document: document });
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.put('/admin/:section/:category/:document', jsonParser, function (req, res) { // new document
            var _id = db.ObjectId(req.params.document);
            var document        = req.body;
            document.date       = Date.now();
            db.updateOne( 'document',  { _id:_id }, document ).then( function( response ) {
                res.json({ status: 'OK', response: response, document: document });
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.delete('/admin/:section/:category/:document', jsonParser, function (req, res) { // new document
            var _id = db.ObjectId(req.params.document);
            db.remove( 'document',  { _id:_id } ).then( function( response ) {
                res.json({ status: 'OK', response: response });
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.get('/admin/:section/:category/:document', function (req, res) {
            var categoryId   = db.ObjectId(req.params.category);
            var documentId   = db.ObjectId(req.params.document);
            db.findOne('category', { _id: categoryId } ).then( function( category ) {
                db.findOne('document', { _id: documentId } ).then( function( document ) {
                    res.render('document', {title:'AfterTrauma > ' + category.title + ' > ' + document.title, section: category.section, document: document } );
                }).catch( function( error ) {
                    //
                    // TODO: error
                    //
                    res.render('error', {title:'AfterTrauma Admin', error: error});
                });
            }).catch( function( error ) {
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
        });
        app.get('/admin/:section/:category/:document/:block', function (req, res) {
            var section     = req.params.section;
            var categoryId  = req.params.category;
            var documentId  = req.params.document;
            var blockIndex  = parseInt(req.params.block);
            var type        = req.query.type;
            db.findOne('category', { _id: db.ObjectId(categoryId) } ).then( function( category ) {
                db.findOne('document', { _id: db.ObjectId(documentId) } ).then( function( document ) {
                    var block = blockIndex >= 0 && blockIndex < document.blocks.length ? document.blocks[ blockIndex ] : {type: type, title:"", content:"", tags:[]};
                    res.render('block', {title:'AfterTrauma > ' + section + ' > ' + category.title + ' > ' + document.title, section: section, document: document, index: blockIndex, block: block} );
                }).catch( function( error ) {
                    //
                    // TODO: error
                    //
                    res.render('error', {title:'AfterTrauma Admin', error: error});
                });
            }).catch( function( error ) {
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
        });
        app.put('/admin/:section/:category/:document/:block', jsonParser, function (req, res) { // update item
            var section     = req.params.section;
            var category    = req.params.category;
            var document    = db.ObjectId(req.params.document);
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
                    $set: {
                        date : Date.now()
                    } 
                };
                operation[ '$set' ][ 'blocks.' + blockIndex ] = block;
            }
            db.updateOne( 'document',  { _id: document }, operation ).then( function( response ) {
                res.json({ status: 'OK', response: response});
            }).catch( function( error ) {
                res.json({ status: 'ERROR', error: error});
            });
        });
        app.delete('/admin/:section/:category/:document/:block', function (req, res) { // delete block
            var section     = req.params.section;
            var category    = req.params.category;
            var document    = db.ObjectId(req.params.document);
            var blockIndex  = parseInt(req.params.block);
            var operation   = { $unset: { } };
            operation['$unset'][ 'blocks.' + blockIndex ] = null;
            db.updateOne( 'document',  { _id: document }, operation ).then( function( response ) {
                db.updateOne( 'document',  { _id: document }, { $pull: { blocks: null }, $set: { date: Date.now() } } ).then( function( response ) {
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
