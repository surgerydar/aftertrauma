//
// 
//
var _db;
var _wsr;
var mailer = require('./mailer.js');
var access = require('./access');

function Profile() {
    
}

Profile.prototype.setup = function( wsr, db ) {
    _db = db;
    _wsr = wsr;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Profile connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Profile.prototype.updateprofile = function( wss, ws, command ) {
    console.log( 'Profile.updateprofile : id:' + command.profile.id + ' username:' + command.profile.username + ' email:' + command.profile.email );
    //
    // update user
    //
    process.nextTick(function(){   
        //console.log('updating user : ' + JSON.stringify(command.profile));
        _db.updateUser(command.profile.id,command.profile).then(function( response ) {
            command.status = 'OK';
            command.response = response;
            ws.send(JSON.stringify(command));
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    }); 
}

Profile.prototype.getpublicprofiles = function( wss, ws, command ) {
    console.log( 'Profile.getpublicprofiles : exclude:' + command.exclude );
    //
    // get list of public profiles
    //
    process.nextTick(function() {  
        let query = {};
        if ( command.exclude ) {
            query = {id:{$not:{$eq:command.exclude}}};
        }
        _db.findUsers(query,{password: 0, email: 0},{}).then(function( response ) {
            command.status = 'OK';
            command.response = response;
            ws.send(JSON.stringify(command));
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    }); 
}

Profile.prototype.findpublicprofiles = function( wss, ws, command ) {
    console.log( 'Profile.findpublicprofiles : exclude:' + command.exclude );
    //
    // update user
    //
    process.nextTick(function() {  
        let query = {};
        if ( command.exclude ) {
            query = {$and:[{id:{$not:{$eq:command.exclude}}},{username: { $regex: '^' + command.search, $options:'i'} }]};
        }
        _db.findUsers(query,{password: 0, email: 0},{}).then(function( response ) {
            command.status = 'OK';
            command.response = response;
            ws.send(JSON.stringify(command));
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    }); 
}

Profile.prototype.filterpublicprofiles = function( wss, ws, command ) {
    console.log( 'Profile.filterpublicprofiles : filter:' + JSON.stringify( command ) );
    //
    // update user
    //
    process.nextTick(function() {  
        try {
            //_db.find('users', command.filter, {password: 0, email: 0}, command.order, command.limit).then(function( response ) {
            _db.findUsers(command.filter,{password: 0, email: 0},{}).then(function( response ) {
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } catch( error ) {
            console.log( 'Profile.filterpublicprofiles : error : ' + error );
        }
    }); 
}

Profile.prototype.blockprofile = function( wss, ws, command ) {
    console.log( 'Profile.blockprofile : id:' + command.id );
    //
    // block user
    //
    process.nextTick(function(){   
        if ( access.verifyCommand( ws, command ) ) {
            _db.updateUser(command.id, { blocked: true }).then(function( response ) {
                //
                // flag all user messages
                //
                _db.find('groupchats',{$or:[{members: command.id},{owner: command.id}]},{},{date:-1}).then(function( response ) {
                    response.forEach( function( chat ) {
                        //console.log( 'Profile.blockprofile : blocking chat : ' + JSON.stringify(chat) );
                        chat.messages.forEach( function( message ) {
                            if ( message.from === command.id ) {
                                message.blocked = true;
                            }    
                        });
                        //
                        // update chat and inform users
                        //
                        var updateCommand = {
                            command: "groupupdatechat",
                            token: command.token,
                            chat: { id: chat.id, messages: chat.messages }
                        };
                        _wsr.message( wss, ws, JSON.stringify( updateCommand ) );
                    });
                }).catch( function( error ) {
                    console.log( 'Profile.blockprofile : unable to find user chats : ' + error );
                });
                //
                // email admin
                //
                var message = "user id : " + command.id + " : complaint : " + command.complaint;
                mailer.send( 'jons@soda.co.uk', 'AfterTrauma user blocked', message );
                //
                //
                //
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

Profile.prototype.unblockprofile = function( wss, ws, command ) {
    console.log( 'Profile.unblockprofile : id:' + command.id );
    //
    // update user
    //
    process.nextTick(function(){   
        if ( access.verifyCommand( ws, command ) ) {
            _db.updateUser(command.id, { blocked: false }).then(function( response ) {
                //
                // unflag all user messages
                //
                _db.find('groupchats',{$or:[{members: command.id},{owner: command.id}]},{},{date:-1}).then(function( response ) {
                    response.forEach( function( chat ) {
                        chat.messages.forEach( function( message ) {
                            if ( message.from === command.id ) {
                                message.blocked = false;
                            }    
                        });
                        //
                        // update chat and inform users
                        //
                        var updateCommand = {
                            command: "groupupdatechat",
                            token: command.token,
                            chat: { id: chat.id, messages: chat.messages }
                        };
                        _wsr.message( wss, ws, JSON.stringify( updateCommand ) );
                    });
                }).catch( function( error ) {
                    console.log( 'Profile.unblockprofile : unable to find user chats : ' + error );
                });
                //
                // email admin
                //
                var message = "user id : " + command.id;
                mailer.send( 'jons@soda.co.uk', 'AfterTrauma user unblocked', message );
                //
                //
                //
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

module.exports = new Profile();

