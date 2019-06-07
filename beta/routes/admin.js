/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
const express = require('express')
const router  = express.Router()
//const fs      = require('fs')
const ws      = require('ws');
const access  = require('../access')

const _ws = new ws( 'wss://aftertrauma.uk:4000');
_ws.on('message', function( message ) {
    try {
        let command = JSON.parse( message );
        if ( command ) {
            console.log('admin recieved command : ' + command.command + ' : status : ' + command.status + ( command.status === 'ERROR' ? ' : ' + JSON.stringify( command.error ) : '' ) ); 
        }
    } catch( error ) {
        
    }
});

module.exports = function( authentication, db ) {
    console.log('loading delta');
    let delta = require('../delta')(db);
    //
    // utility functions
    //
    let capitalise = ( word )=>{
        return word && word.charAt(0).toUpperCase() + word.slice(1);
    }
    let formatResponse = ( data, status, message )=>{
        let response = {};
        if ( message ) response[ 'message' ] = message;
        if ( status ) response[ 'status' ] = status;
        if ( data ) response[ 'data' ] = data;
        return response;
    }
    //
    // routes
    //
    /*
    console.log( 'setting media routes' );
    const mediaDirectory = './media';
    router.get('/media/:type', function (req, res) { // return all media of type
        fs.readdir(mediaDirectory, (err, files) => {
            let media  = [];
            files.forEach(file => {
                console.log(file);
            });
        });
        res.render('media', {media:media}); 
    });
    */
    //
    //
    //
    console.log( 'setting content routes' );
    router.get('/contents', function (req, res) { // return all documents
         db.find('document', {} ).then( ( documents )=>{
             res.json({ status: 'OK', response: documents});
        }).catch( ( error )=>{
             res.json({ status: 'ERROR', error: error});
        });
    });

    router.get('/documents/:date/:format', function (req, res) {
        let date = req.params.date > 0 ? req.params.date : Date.now();
        let format = req.params.format;
        let query = { date: { $lt: date } };
        db.find('document', query ).then( ( documents )=>{
            if ( format === 'html' ) {
                res.render('documents', {documents:documents}); 
            } else {
                res.json({ status: 'OK', response: documents});
            }
        }).catch( ( error )=>{
            if ( format === 'html' ) {
                res.render('error', {title:'AfterTrauma Admin', error: error}); 
            } else {
                res.json({ status: 'ERROR', error: error});
            }
        });
    });
    router.get('/manifest/:date', function (req, res) {
        delta.getManifest( parseInt(req.params.date) ).then( ( response )=>{
            res.json({ status: 'OK', response: response});
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    //
    // 
    //
    console.log( 'setting admin routes' );
    router.get('/', authentication, function (req, res) {
        res.render('admin', {title:'AfterTrauma Admin'});
    });
	//
	// users specialisation
	//
    router.get('/users', authentication, function (req, res) {
        db.find( 'users', {}, { password: 0 }, { username: 1 } ).then( ( response )=>{
            res.render( 'users', { title:'AfterTrauma > Users', users: response } );
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    router.get('/users/:user', authentication, function (req, res) {
       var _id         = db.ObjectId(req.params.user);
       db.findOne( 'users', { _id: _id } ).then( ( user )=>{
            res.render( 'user', { title:'AfterTrauma > Users > ' + user.username, user: user } );
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    router.post('/users', authentication, function (req, res) { // new user
        let user        = req.body;
        user.joined     = Date.now();
        user.date       = user.joined;
        db.insert( 'users',  user ).then( ( response )=>{
            res.json({ status: 'OK', response: response, user: user });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.put('/users/:user', authentication, function (req, res) { // update user
        let user	= req.body;
        user.date	= Date.now();
        let _id     = db.ObjectId(req.params.user);
        db.updateOne( 'users',  { _id: _id }, { $set: user } ).then( ( response )=>{
            res.json({ status: 'OK', response: response});
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.delete('/users/:user', authentication, function (req, res) { // delete document
        let _id = db.ObjectId(req.params.user);
        db.remove( 'users',  { _id:_id } ).then( ( response )=>{
            //
            //
            //
            res.json({ status: 'OK', response: response });
        }).catch( ( error )=>{
            console.log( 'delete user : error : ' + error );
            res.json({ status: 'ERROR', error: error});
        });
    });
    //
    //
    //
    router.put('/users/block/:user', authentication, function (req, res) { // block user
        console.log('blocking user : ' + req.params.user );
        let _id = db.ObjectId(req.params.user);
        db.findOne( 'users', { _id: _id } ).then( ( user )=>{
            let command = {
                command: 'blockprofile',
                token: access.sign({ user: req.user.username }),
                id: user.id
            };
            _ws.send(JSON.stringify(command));
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    router.put('/users/unblock/:user', authentication, function (req, res) { // unblock user
        console.log('unblocking user : ' + req.params.user );
        let _id = db.ObjectId(req.params.user);
        db.findOne( 'users', { _id: _id } ).then( ( user )=>{
            let command = {
                command: 'unblockprofile',
                token: access.sign({ user: req.user.username }),
                id: user.id
            };
            _ws.send(JSON.stringify(command));
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    //
    //
    //
    router.put('/users/admin/:user', authentication, function (req, res) { // admin user
        console.log('admining user : ' + req.params.user );
        let _id = db.ObjectId(req.params.user);
        db.updateOne( 'users', { _id: _id }, { $set: { admin: false } } ).then( ( user )=>{
            res.json({ status: 'OK', response: response });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error });
        });
    });
    router.put('/users/unadmin/:user', authentication, function (req, res) { // unadmin user
        console.log('unadmining user : ' + req.params.user );
        var _id = db.ObjectId(req.params.user);
        db.updateOne( 'users', { _id: _id }, { $set: { admin: false } } ).then( ( user )=>{
            res.json({ status: 'OK', response: response });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error });
        });
    });
	//
	// challenge specialisation
	//
    router.get('/challenges', authentication, function (req, res) {
        db.find( 'challenge', {}, { name: 1 } ).then( ( response )=>{
            res.render( 'challenges', { title:'AfterTrauma > Challenges', challenges: response } );
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    router.get('/challenges/:challenge', authentication, function (req, res) {
		let _id = db.ObjectId(req.params.challenge);
        db.findOne( 'challenge', { _id:_id } ).then( ( challenge )=>{
            res.render( 'challenge', { title:'AfterTrauma > Challenges > ' + challenge.name, challenge: challenge } );
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    router.post('/challenges', authentication, function (req, res) { // new challenge
        let challenge        = req.body;
        challenge.date       = Date.now();
        db.insert( 'challenge',  challenge ).then( ( response )=>{
            console.log( 'add challenge : ' + JSON.stringify(challenge) );
            delta.addChallenge( challenge._id ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.addChallenge : error : ' + error );
            });
            res.json({ status: 'OK', response: response, challenge: challenge });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.put('/challenges/:challenge', authentication, function (req, res) { // update challenge
        let challenge	= req.body;
        challenge.date	= Date.now();
        let _id         = db.ObjectId(req.params.challenge);
        db.updateOne( 'challenge',  { _id: _id }, { $set: challenge } ).then( ( response )=>{
            res.json({ status: 'OK', response: response});
        }).catch( ( error )=>{
            console.log( 'update challenge : ' + req.params.challenge );
            delta.updateChallenge( req.params.challenge ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.updateChallenge : error : ' + error );
            });
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.delete('/challenges/:challenge', authentication, function (req, res) { // delete document
        let _id = db.ObjectId(req.params.challenge);
        db.remove( 'challenge',  { _id:_id } ).then( ( response )=>{
            //
            // TODO: record delta
            //
			
            console.log( 'delted challenge : ' + req.params.challenge );
            delta.removeChallenge( req.params.challenge ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.removeChallenge : error : ' + error );
            });
			
            //
            //
            //
            res.json({ status: 'OK', response: response });
        }).catch( ( error )=>{
            console.log( 'delete challenge : error : ' + error );
            res.json({ status: 'ERROR', error: error});
        });
    });
    //
    // categories
    //
    router.get('/:section', authentication, function (req, res) { // get section categories
        let section = req.params.section;
        db.find( 'category', { section: section }, { title: 1 }, { index: 1 } ).then( ( response )=>{
            res.render('section', {title:'AfterTrauma > ' + capitalise( section ), section: section, categories: response });
        }).catch( ( error )=>{
            //
            // TODO: error
            //
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });

    });
    router.post('/:section', authentication, function (req, res) { // new category
        let section         = req.params.section;
        let category        = req.body;
        category.date       = Date.now();
        category.section    = section;
        db.insert( 'category',  category ).then( ( response )=>{
            res.json({ status: 'OK', response: response, category: category });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.put('/:section/:category', authentication, function (req, res) { // update category
        let category    = req.body;
        let _id         = db.ObjectId(req.params.category);
        let update = {
            title: category.title,
            date: Date.now()
        };
        //
        // update category
        //
        db.updateOne( 'category',  { _id: _id }, { $set: update } ).then( ( response )=>{
            //
            // update document order
            //
            // TODO: restructure this to handle errors correctly
            //
            if ( category.order ) {
                category.order.forEach((order)=>{
                    let documentId = db.ObjectId(order.id);
                    db.updateOne( 'document', { _id: documentId }, { $set: { index: order.index } } ).then( ( response )=>{
                        
                    }).catch( ( error )=>{
                        res.json({ status: 'ERROR', error: error});
                    });    
                }); 
                res.json({ status: 'OK', response: response});
            } else {
                res.json({ status: 'OK', response: response});
            }
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.delete('/:section/:category', authentication, function (req, res) {
        let _id = db.ObjectId(req.params.category);
        db.remove( 'category', { _id: _id } ).then( ( response )=>{ // TODO: should remove documents attached to category
            res.json({ status: 'OK', response: response});
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });

    });
    router.put('/:section', authentication, function (req, res) { // update category order
        let section = req.params.section;
        let update  = req.body;
        if ( update.order ) {
            //
            // TODO: restructure this to handle errors correctly
            //
            update.order.forEach( ( order )=>{
                var categoryId = db.ObjectId(order.id);
                db.updateOne( 'category', { _id: categoryId }, { $set: { index: order.index } } ).then( ( response )=>{

                }).catch( ( error )=>{
                    res.json({ status: 'ERROR', error: error});
                });
            });
        }
        res.json({ status: 'OK', response: ''});
    });
    //
    // category documents
    //
    router.get('/:section/:category', authentication, function (req, res) {
        let section = req.params.section;
        let _id = db.ObjectId(req.params.category);
        let format = req.query.format;
        db.findOne( 'category', { _id: _id } ).then( ( category )=>{
            db.find( 'document', { category: req.params.category }, {}, { index: 1 } ).then( ( documents )=>{
                if ( format === 'json' ) {
                    res.json( documents );
                } else {
                    res.render('category', {title:'AfterTrauma > ' + capitalise( section ) + ' > ' + category.title, section: category.section, category: category, documents: documents });
                }
            }).catch( ( error )=>{
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });

    });
    router.post('/:section/:category', authentication, function (req, res) { // new document
        let section         = req.params.section;
        let category        = req.params.category;
        let document        = req.body;
        document.date       = Date.now();
        document.category   = category;
        document.blocks     = [];
        db.insert( 'document',  document ).then( ( response )=>{
            //
            // record delta
            //
            console.log( 'inserted document : ' + document._id );
            //let idType = typeof document._id;
            //let idValueOf = document._id.valueOf();
            //let idToString = document._id.toString();
            //let idStr = document._id.str;
            //console.log( 'idType=' + idType + ' idValueOf:' + idValueOf + ' idToString:' + idToString + ' idStr:' + idStr );
            delta.addDocument( section, category, document._id.toString(), document.title ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.addDocument : error : ' + error );
            });
            //
            //
            //
            res.json({ status: 'OK', response: response, document: document });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    
    router.put('/:section/:category/:document', authentication, function (req, res) { // update document
        let _id = db.ObjectId(req.params.document);
        let document        = req.body;
        document.date       = Date.now();
        db.updateOne( 'document',  { _id:_id }, { $set: document } ).then( ( response )=>{
            //
            // record delta
            //
            console.log( 'updated document : ' + req.params.document );
            delta.updateDocument( req.params.section, req.params.category, req.params.document, document.title ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.updateDocument : error : ' + error );
            });
            //
            //
            //
            res.json({ status: 'OK', response: response, document: document });
        }).catch( ( error )=>{
            console.log( 'update document : error : ' + error );
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.delete('/:section/:category/:document', authentication, function (req, res) { // delete document
        let _id = db.ObjectId(req.params.document);
        db.remove( 'document',  { _id:_id } ).then( ( response )=>{
            //
            // record delta
            //
            console.log( 'delted document : ' + req.params.document );
            delta.removeDocument( req.params.section, req.params.category, req.params.document ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.removeDocument : error : ' + error );
            });
            //
            //
            //
            res.json({ status: 'OK', response: response });
        }).catch( ( error )=>{
            console.log( 'delete document : error : ' + error );
            res.json({ status: 'ERROR', error: error});
        });
    });
    //
    // doument blocks
    //
    router.get('/:section/:category/:document', authentication, function (req, res) {
        let section     = req.params.section;
        let categoryId  = db.ObjectId(req.params.category);
        let documentId  = db.ObjectId(req.params.document);
        db.findOne('category', { _id: categoryId } ).then( ( category )=>{
            db.findOne('document', { _id: documentId } ).then( ( document )=>{
                res.render('document', {title:'AfterTrauma > ' + capitalise( section ) + ' > ' + category.title + ' > ' + document.title, section: category.section, document: document } );
            }).catch( ( error )=>{
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    router.get('/:section/:category/:document/:block', authentication, function (req, res) { // get block
        let section     = req.params.section;
        let categoryId  = req.params.category;
        let documentId  = req.params.document;
        let blockIndex  = parseInt(req.params.block);
        let type        = req.query.type;
        db.findOne('category', { _id: db.ObjectId(categoryId) } ).then( ( category )=>{
            db.findOne('document', { _id: db.ObjectId(documentId) } ).then( ( document )=>{
                var block = blockIndex >= 0 && blockIndex < document.blocks.length ? document.blocks[ blockIndex ] : {type: type, title:"", content:"", tags:[]};
                res.render('block', {title:'AfterTrauma > ' + capitalise( section ) + ' > ' + category.title + ' > ' + document.title + ' > block ' + blockIndex, section: section, document: document, index: blockIndex, block: block} );
            }).catch( ( error )=>{
                //
                // TODO: error
                //
                res.render('error', {title:'AfterTrauma Admin', error: error});
            });
        }).catch( ( error )=>{
            res.render('error', {title:'AfterTrauma Admin', error: error});
        });
    });
    
    router.put('/:section/:category/:document/:block', authentication, function (req, res) { // update block
        let section     = req.params.section;
        let category    = req.params.category;
        let document    = db.ObjectId(req.params.document);
        let blockIndex  = parseInt(req.params.block);
        let block       = req.body; 
        let operation;
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
        db.updateOne( 'document',  { _id: document }, operation ).then( ( response )=>{
            //
            // record delta
            //
            delta.updateDocument( section, category, req.params.document, undefined ).then( ( response )=>{
            }).catch( ( error )=>{
                console.log( 'delta.updateDocument : error : ' + error );
            });
            //
            //
            //
            res.json({ status: 'OK', response: response});
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    router.delete('/:section/:category/:document/:block', authentication, function (req, res) { // delete block
        let section     = req.params.section;
        let category    = req.params.category;
        let document    = db.ObjectId(req.params.document);
        let blockIndex  = parseInt(req.params.block);
        let operation   = { $unset: { } };
        operation['$unset'][ 'blocks.' + blockIndex ] = null;
        db.updateOne( 'document',  { _id: document }, operation ).then( ( response )=>{
            db.updateOne( 'document',  { _id: document }, { $pull: { blocks: null }, $set: { date: Date.now() } } ).then( ( response )=>{
                //
                // record delta
                //
                delta.updateDocument( section, category, req.params.document, undefined ).then( ( response )=>{
                }).catch( ( error )=>{
                    console.log( 'delta.updateDocument : error : ' + error );
                });
                //
                //
                //
                res.json({ status: 'OK', response: response});
            }).catch( ( error )=>{
                res.json({ status: 'ERROR', error: error});
            });
        }).catch( ( error )=>{
            res.json({ status: 'ERROR', error: error});
        });
    });
    //
    //
    //
    return router;
}