var env = process.env;
//
//
//
var express = require('express');
var bodyParser = require('body-parser');
var jsonParser = bodyParser.json();
//
//
//		
var app = express();
var io = null;
var mailer = require('./mailer.js');
var qml = require('./QML.js');
//
// start app
//
var server = app.listen(env.NODE_PORT || 3000, env.NODE_IP || 'localhost', function () {
  console.log('Application worker ' + process.pid + ' started...');
});
//
// start ws
//
var sketchsession = require('./sketchsession.js');
var WebSocket = require('ws');
var wss = new WebSocket.Server({ server });
wss.on('connection', function(ws) {
    ws.on('message', function(message) {
        sketchsession.processMessage(wss,ws,message);
    });
    ws.send(JSON.stringify({command:'welcome'}));
});
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
    //
    //
    //
    bodyParser.json( {limit:'5mb'} );
	//
	// configure express
	//
	app.set('view engine', 'pug');
	app.use(express.static(__dirname+'/static'));
    //
    // express routes
    //
	app.get('/', function (req, res) {
        res.json({ status: 'ok' });
	});
    //
    // user
    //
    app.post('/user', jsonParser, function (req, res) {
        // create new user
        console.log( 'new user : ' + JSON.stringify(req.body) );
        db.putUser( req.body ).then( function( response ) {
            /* TODO: reinstate this
            //
            // email confirmation
            //
            var message = 'Hi ' + req.body.username + ', welcome to collaborative sketch at Ravensbourne<br/>';
            message += 'You can access your sketches using the mobile app available at:<br/>';
            message += 'Android: http://ravensbournetable.co.uk/android/<br/>';
            message += 'iOS: http://store<br/>';
            message += 'enter the following code when you first launch the app:<br/>'
            message += req.body.id;
            mailer.send( req.body.email, 'Welcome to collaborative sketch at Ravensbourne', message ).then( function( response ) {
                res.json( {status: 'OK'} );
            }).catch( function( error ) {
                res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
            });
            */
            var echo = req.body;
            echo.password = undefined;
            res.json( formatResponse( echo, 'OK', response ) );
        } ).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
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
    app.post('/validate', jsonParser, function(req, res) {
        // validate user
        db.validateUser(req.body).then( function( response ) {
            console.log( '/validate/' + req.body.username + ':' + JSON.stringify(response) );
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
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
        // delete user
        db.deleteUser(req.params.id).then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    //
    // autocomplete lists
    //
    app.get('/userlist', function(req, res) {
        // get userlist
        db.getUserList().then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    app.get('/grouplist', function(req, res) {
        // get userlist
        db.getGroupList().then( function( response ) {
            res.json( formatResponse( response, 'OK' ) );
        }).catch( function( error ) {
            res.json( formatResponse( null, 'ERROR', JSON.stringify( error ) ) );
        });
    });
    //
    // diary
    //
    app.post('/diary', jsonParser, function (req, res) {
        // create diary entry
        db.putEntity( req.body ).then( function( response ) {
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.put('/diary/:id', jsonParser, function (req, res) {
        // update diary entry
        db.updateEntity( req.params.id, req.body ).then( function( response ) {
            //
            //
            //
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    //
    // conversation
    //
    app.post('/conversation', jsonParser, function (req, res) {
        // create new conversation
        db.putEntity( req.body ).then( function( response ) {
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.put('/conversation/:id', jsonParser, function (req, res) {
        // update conversation
        db.updateEntity( req.params.id, req.body ).then( function( response ) {
            //
            //
            //
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    app.put('/snippet/:id', jsonParser, function (req, res) {
        // add snippet to conversation
        db.updateConversation( req.params.id, req.body ).then( function( response ) {
            //
            //
            //
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
    //
    // groups
    //
    app.post('/group', jsonParser, function (req, res) {
        // create new conversation
        db.putEntity( req.body ).then( function( response ) {
            res.json( {status: 'OK'} );
        } ).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
   //
    // QML renderers
    //
    app.get('/qml/people', function(req, res) {
        try {
             db.findUsers(req.query.filter).then( function( response ) {
                //console.log( '/people?filter=' + req.query.filter + ' : ' + JSON.stringify(response) );
                qml.render('User',response).then( function( response ) {
                    res.send(response);
                } ).catch( function( error ) {
                    res.status(500).send( "app.get('/people') : error : " + error );
                });
                
             }).catch( function( error ) {
                res.status(500).send( "app.get('/people') : error : " + error );
            });
        } catch( error ) {
            res.status(500).send( "app.get('/people') : error : " + error );
        }
    });
    app.get('/qml/diary', function(req, res) {
        try {
             db.findUserEntities(req.query.user,'diary',req.query.filter,{date:1}).then( function( response ) {
                //console.log( '/qml/diary?user=' + req.query.user + '&filter=' + req.query.filter + ' : ' + JSON.stringify(response) );
                console.log( '/qml/diary?user=' + req.query.user + ' : ' + JSON.stringify(response) );
                qml.render('Diary',response).then( function( response ) {
                    res.send(response);
                } ).catch( function( error ) {
                    res.status(500).send( "app.get('/qml/diary') : error : " + error );
                });
                
             }).catch( function( error ) {
                res.status(500).send( "app.get('/qml/diary') : error : " + error );
            });
        } catch( error ) {
            res.status(500).send( "app.get('/qml/diary') : error : " + error );
        }
    });
    app.get('/qml/conversations', function(req, res) {
        try {
             db.findUserConversations(req.query.user,req.query.privacy,req.query.filter).then( function( response ) {
                //console.log( '/qml/diary?user=' + req.query.user + '&filter=' + req.query.filter + ' : ' + JSON.stringify(response) );
                console.log( '/qml/conversations?user=' + req.query.user + ' : ' + JSON.stringify(response) );
                qml.render('Conversation',response).then( function( response ) {
                    res.send(response);
                } ).catch( function( error ) {
                    res.status(500).send( "app.get('/qml/conversations') : error : " + error );
                });
                
             }).catch( function( error ) {
                res.status(500).send( "app.get('/qml/conversations') : error : " + error );
            });
        } catch( error ) {
            res.status(500).send( "app.get('/qml/conversations') : error : " + error );
        }
    });
    app.get('/qml/conversation', function(req, res) {
        try {
             db.getEntity(req.query.id).then( function( response ) {
                //console.log( '/qml/diary?user=' + req.query.user + '&filter=' + req.query.filter + ' : ' + JSON.stringify(response) );
                console.log( '/qml/conversation?id=' + req.query.id + ' : ' + JSON.stringify(response) );
                 if ( !response.snippets ) response.snippets = [];
                qml.render('Snippet',response.snippets).then( function( response ) {
                    res.send(response);
                } ).catch( function( error ) {
                    res.status(500).send( "app.get('/qml/conversation') : error : " + error );
                });
                
             }).catch( function( error ) {
                res.status(500).send( "app.get('/qml/conversation') : error : " + error );
            });
        } catch( error ) {
            res.status(500).send( "app.get('/qml/conversation') : error : " + error );
        }
    });
    app.get('/qml/groups', function(req, res) {
        try {
             db.findUserGroups(req.query.user,req.query.filter).then( function( response ) {
                //console.log( '/qml/diary?user=' + req.query.user + '&filter=' + req.query.filter + ' : ' + JSON.stringify(response) );
                console.log( '/qml/groups?user=' + req.query.user + ' : ' + JSON.stringify(response) );
                qml.render('Group',response).then( function( response ) {
                    res.send(response);
                } ).catch( function( error ) {
                    res.status(500).send( "app.get('/qml/conversations') : error : " + error );
                });
                
             }).catch( function( error ) {
                res.status(500).send( "app.get('/qml/conversations') : error : " + error );
            });
        } catch( error ) {
            res.status(500).send( "app.get('/qml/conversations') : error : " + error );
        }
    });
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
    app.get('/defaults', function(req, res) {
        // get single route
        db.setDefaults();
        res.json( {status: 'OK'} );
    });
    app.get('/testemail/:message', function(req,res) {
        mailer.send( 'jons@soda.co.uk', 'Testing collaborative sketch at Ravensbourne', req.params.message ).then( function( response ) {
            res.json( {status: 'OK'} );
        }).catch( function( error ) {
            res.json( {status: 'ERROR', message: JSON.stringify( error ) } );
        });
    });
}).catch( function( err ) {
	console.log( 'unable to connect to database : ' + err );
});

