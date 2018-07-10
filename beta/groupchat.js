//
// 
//
var _db;
var _live = [];
var jwt = require('jsonwebtoken');
/*
    chat {
        _id: ObjectId(),
        id: client side id ( generated on creation ),
        date: timestamp ( last update ),
        owner: user id,
        subject: free text,
        public: true|false,
        tags: [ tag, tag, tag ],
        members: [ id, id, id ],
        invited: [ id, id, id ],
        active: [ id, id, id ]
    }
*/
//
//
//
function findLive( id ) {
    for ( var i = 0; i < _live.length; i++ ) {
        if ( _live[ i ].id === id ) {
            return _live[ i ];
        }
    }
    return undefined;
}

function addToLive( id, username, ws ) {
    let live = findLive(id);
    if ( live ) {
       live.ws = ws; 
    } else {
        _live.push( { id: id, username: username, ws: ws } );
    }
    ws.on('close', (code,reason) => { 
        removeFromLive(id);
    });
}

function removeFromLive( id ) {
    for ( var i = 0; i < _live.length; i++ ) {
        if ( _live[ i ].id === id ) {
            console.log( 'GroupChat removing live connection ' + _live[ i ].username );
            _live.splice(i,1);
            break;
        }
    }    
}

function sendToLive( id, message ) {
    let live = findLive( id );
    if ( live ) {
        console.log( 'sending to live : ' + id + ' : ' + message );
        live.ws.send( JSON.stringify( message ) );
    }
}

function sendToAllLive( message ) {
    for ( var i = 0; i < _live.length; i++ ) {
        try {
            _live[ i ].ws.send( JSON.stringify( message ) );
        } catch( error ) {
            console.error( 'groupchat sendToAllLive : error sending to : ' + _live[ i ].id + ' : ' + error );
        }
    }
}

function sendToMembers( chat, command, exclude ) {
    if ( chat.owner !== exclude ) sendToLive( chat.owner, command );
    chat.members.forEach( function( member ) {
        if( member !== exclude ) sendToLive( member, command );
    });
}

function sendToActiveMembers( chat, command, exclude ) {
    if ( chat.owner !== exclude ) sendToLive( chat.owner, command );
    chat.members.forEach( function( member ) {
        if ( member !== exclude && chat.active.indexOf(member) >= 0 ) { // check user has accepted invite 
            sendToLive( member, command );
        }    
    });
}

function inviteMembers( chat ) {
    var invite = {
        command: 'groupchatinvite',
        status: 'OK',
        chat: {
            id: chat.id,
            date: chat.date,
            owner: chat.owner,
            subject: chat.subject
        }
    };
    chat.members.forEach( function( member ) {
        if ( chat.invited.indexOf(member) < 0 && chat.active.indexOf(member) ) { // check user has not been invited and is not active
            chat.invited.push(member);
            sendToLive( member, invite );
        }    
    });
}

function verify( ws, command ) {
    if ( command.token ) {
        try {
            if( jwt.verify( command.token, 'afterparty' ) ) {
                return true
            }
            command.error = 'authentication required';
        } catch( error ) {
            command.error = error;
        }
    } else {
        command.error = 'authentication required';
    }
    command.status = 'ERROR';
    ws.send(JSON.stringify(command));
    return false;
}
//
//
//
function GroupChat() {
}

GroupChat.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'GroupChat connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

GroupChat.prototype.groupgetuserchats = function( wss, ws, command ) {
    console.log( 'GroupChat.getuserchats : user id:' + command.id );
    //
    // add chat to db
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            // get all group chats user is a member of
            _db.find('groupchats',{$or:[{members: command.id},{owner: command.id},{public:true}]},{},{date:-1}).then(function( response ) {
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

GroupChat.prototype.groupcreatechat = function( wss, ws, command ) {
    console.log( 'GroupChat.groupcreatechat : ' + JSON.stringify(command.chat) );
    //
    // add chat to db
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            var chat = command.chat;
            chat.date = Date.now();
            chat.invited = [];
            chat.active = [];
            inviteMembers( chat );
            _db.insert('groupchats', chat ).then(function( response ) {
                //
                //
                //
                command.status = 'OK';
                if ( chat.public ) {
                    sendToAllLive( command );
                } else {
                    //
                    // alert members
                    //
                    sendToMembers( chat, command, chat.owner );
                    //
                    // respond to caller
                    //
                    command.response = response;
                    ws.send(JSON.stringify(command));
                }
                //
                //
                //
                
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupupdatechat = function( wss, ws, command ) {
    console.log( 'GroupChat.groupupdatechat : ' + JSON.stringify(command.chat) );
    //
    // add chat to db
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            var chat = command.chat;
            chat.date = Date.now();
            _db.updateOne( 'groupchats', { id: chat.id }, { $set: chat } ).then(function( response ) {
                //
                //
                //
                command.status = 'OK';
                //command.response = response;
                //ws.send(JSON.stringify(command));
                //
                //
                //
                sendToMembers(chat,command);
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupacceptinvite = function( wss, ws, command ) {
    console.log( 'GroupChat.acceptinvite : chat ' +  command.chatid + ' user ' + command.userid );
    //
    // update chat status
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            _db.findOne('groupchats', { id: command.chatid }, {}).then(function( chat ) {
                var invitedIndex = chat.invited.indexOf( command.userid );
                if ( invitedIndex >= 0 ) {
                    //
                    // remove member from invited
                    //
                    chat.invited.splice( invitedIndex, 1 );
                    //
                    // add member to active
                    //
                    if ( chat.active.indexOf( command.userid ) < 0 ) { // this shouldn't be the case
                        chat.active.push( command.userid );
                    } else {
                        console.log( 'GroupChat.acceptinvite : error : user ' + command.userid + ' is already active' );
                    }
                    //
                    // update timestamp
                    //
                    chat.date = Date.now();
                    _db.updateOne( 'groupchats', { id: command.chatid }, { $set: chat } ).then( function( response ) {
                        //
                        // respond to caller
                        //
                        command.status = 'OK';
                        ws.send(JSON.stringify(command));
                        //
                        // inform active members
                        //
                        sendToActiveMembers( chat, {
                            command: 'groupupdatechat',
                            status: 'OK',
                            chat: chat
                        });
                    }).catch( function( error) {
                        command.status = 'ERROR';
                        command.error = error;
                        ws.send(JSON.stringify(command));
                    });
                } else {
                    command.status = 'ERROR';
                    command.error = 'invalid invite';
                    ws.send(JSON.stringify(command));
                }
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupdeclineinvite = function( wss, ws, command ) { 
    console.log( 'GroupChat.groupdeclineinvite : chat ' +  command.chatid + ' user ' + command.userid );
    //
    // update chat status
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            _db.findOne('groupchats', { id: command.chatid }, {}).then(function( chat ) {
                let updated = false;
                let index = chat.members.indexOf( command.userid );
                if ( index >= 0 ) {
                    updated = true;
                    chat.members.splice( index, 1 );
                }
                index = chat.invited.indexOf( command.userid );
                if ( index >= 0 ) {
                    updated = true;
                    chat.invited.splice( index, 1 );
                }
                if ( save ) {
                    //
                    // update timestamp
                    //
                    chat.date = Date.now();
                    _db.updateOne( 'groupchats', { id: command.chatid }, { $set: chat } ).then( function( response ) {
                        //
                        // respond to caller
                        //
                        command.status = 'OK';
                        ws.send(JSON.stringify(command));
                        //
                        // inform active members
                        //
                        sendToActiveMembers( chat, {
                            command: 'groupupdatechat',
                            status: 'OK',
                            chat: chat
                        });
                    }).catch( function( error) {
                        command.status = 'ERROR';
                        command.error = error;
                        ws.send(JSON.stringify(command));
                    });
                } else {
                    command.status = 'ERROR';
                    command.error = 'user is not a member of this chat';
                    ws.send(JSON.stringify(command));                    
                }
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupjoinchat = function( wss, ws, command ) {
    console.log( 'GroupChat.groupjoinchat : ' +  command.chatid + ' user ' + command.userid );
    //
    // join chat
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            _db.findOne('groupchats', { id: command.chatid, public: true }).then(function( chat ) {
                //
                // check user is not already a member
                //
                if ( chat.members.indexOf( command.userid ) < 0 ) {
                    //
                    // add member
                    //
                    chat.members.push( command.userid );
                    chat.active.push( command.userid );
                    chat.date = Date.now();
                    _db.updateOne( 'groupchats', { id: command.chatid }, { $set: chat } ).then( function( response ) {
                        //
                        // respond to caller
                        //
                        command.status = 'OK';
                        command.response = response;
                        ws.send(JSON.stringify(command));
                        //
                        // inform active members
                        //
                        sendToActiveMembers( chat, {
                            command: 'groupupdatechat',
                            status: 'OK',
                            chat: chat
                        });
                    }).catch( function( error) {
                        command.status = 'ERROR';
                        command.error = error;
                        ws.send(JSON.stringify(command));
                    });
                } else {
                    command.status = 'ERROR';
                    command.error = 'already a member';
                    ws.send(JSON.stringify(command));
                }
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupleavechat = function( wss, ws, command ) {
    console.log( 'GroupChat.groupleavechat : ' +  command.chatid + ' user ' + command.userid );
    //
    // leave chat
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            _db.findOne('groupchats', { id: command.chatid }).then(function( chat ) {
                //
                // remove user from lists
                //
                var index = chat.members.indexOf( command.userid );
                if ( index >= 0 ) {
                    chat.members.splice( index, 1 );
                }
                index = chat.invited.indexOf( command.userid );
                if ( index >= 0 ) {
                    chat.invited.splice( index, 1 );
                }
                index = chat.active.indexOf( command.userid );
                if ( index >= 0 ) {
                    chat.active.splice( index, 1 );
                }
                //
                // update
                //
                chat.date = Date.now();
                _db.updateOne( 'groupchats', { id: command.chatid }, { $set: chat } ).then( function( response ) {
                    //
                    // respond to caller
                    //
                    command.status = 'OK';
                    command.response = response;
                    ws.send(JSON.stringify(command));
                    //
                    // inform active members
                    //
                    sendToActiveMembers( chat, {
                        command: 'groupupdatechat',
                        status: 'OK',
                        chat: chat
                    } );
                }).catch( function( error) {
                    command.status = 'ERROR';
                    command.error = error;
                    ws.send(JSON.stringify(command));
                });
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupremovechat = function( wss, ws, command ) {
    console.log( 'GroupChat.groupremovechat : chat ' + command.chatid + 'from user:' + command.userid );
    //
    // remove chat
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            //
            // only allow remove from the owner
            //
            _db.findOne('groupchats', { id: command.chatid }).then(function( chat ) {
                _db.remove('groupchats', { id: command.chatid, owner: command.userid }).then(function( response ) {
                    command.status = 'OK';
                    //command.response = response;
                    //ws.send(JSON.stringify(command));
                    sendToMembers( chat, command );
                }).catch( function( error ) {
                    command.status = 'ERROR';
                    command.error = error;
                    ws.send(JSON.stringify(command));
                });
            }).catch(function(error) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupsendmessage = function( wss, ws, command ) {
    //
    // message should be in the following format
    // { id: guid, from: userid, message: text }
    //
    console.log( 'GroupChat.groupsendmessage : ' + JSON.stringify( command ) );
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            _db.findOne('groupchats', { $and: [ { id: command.chatid }, { $or: [ { owner: command.userid }, { members: command.userid }, { public: true }]}]},{}).then(function( chat ) {
                //
                // add message
                //
                chat.date = Date.now();
                command.message.date = Date.now();
                if ( chat.messages === undefined ) chat.messages = [];
                chat.messages.push(command.message);
                console.log( 'GroupChat.groupsendmessage : updating chat : ' + command.chatid );
                //
                // update
                // TODO: look at pushing message using mongo
                //
                _db.updateOne('groupchats', { id: command.chatid }, {$set: chat }).then(function( response ) {
                    //
                    // respond to caller
                    //
                    command.status = 'OK';
                    //command.response = response; // JONS: no need to return response
                    //ws.send(JSON.stringify(command)); // JONS: will be handled by sendToActiveMembers
                    //
                    // forward to active members
                    //
                    sendToActiveMembers( chat, command );
                }).catch( function( error ) {
                    command.status = 'ERROR';
                    command.error = error;
                    ws.send(JSON.stringify(command));
                });
            }).catch( function( error ) {
                console.log('GroupChat.groupsendmessage : unable to find chat : ' + command.chatid + ' : error : ' + JSON.stringify( error ) );
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}

GroupChat.prototype.groupremovemessage = function( wss, ws, command ) {
    //
    // message should be in the following format
    // { id: guid, from: userid, message: text }
    //
    console.log( 'GroupChat.groupremovemessage : chat id:' + command.chatid + 'from user ' + command.userid + ' message:' + command.messageid );
    //
    // update chat status
    //
    process.nextTick(function(){   
        if ( verify( ws, command ) ) {
            _db.findOne('groupchats', { $and: [ { id: command.chatid }, { $or: [ { owner: command.userid }, { members: command.userid } ]}]},{}).then(function( chat ) {
                //
                // remove message
                //
                let count = chat.messages.length;
                for ( var i = 0; i < count; i++ ) {
                    if ( chat.messages[ i ].id === command.messageid ) {
                        if ( chat.messages[ i ].from === command.userid ) {
                            chat.messages.splice(i,1);
                        }
                        break;
                    }
                }
                //
                // update
                //
                _db.updateOne('groupchats', { id: command.chatid }, { $set: chat }).then(function( response ) {
                    //
                    // respond to caller
                    //
                    command.status = 'OK';
                    command.response = response;
                    ws.send(JSON.stringify(command));
                    //
                    // forward to active members
                    //
                    sendToActiveMembers( chat, command );
                }).catch( function( error ) {
                    command.status = 'ERROR';
                    command.error = error;
                    ws.send(JSON.stringify(command));
                });
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        }
    }); 
}


GroupChat.prototype.groupgolive = function( wss, ws, command ) {
    console.log( 'GroupChat.groupgolive : id:' + command.id + ' username:' + command.username );
    //
    //
    //
    addToLive( command.id, command.username, ws );
    process.nextTick(function(){
        command.status = 'OK';
        
    });
}

GroupChat.prototype.groupfilterchats = function( wss, ws, command ) {
    console.log( 'GroupChat.groupfilterchats : filter:' + JSON.stringify( command ) );
    //
    // update user
    //
    process.nextTick(function() {  
        try {
            _db.find('groupchats', command.filter, {}, command.order || {}, command.limit || 0).then(function( response ) {
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } catch( error ) {
            console.log( 'GroupChat.filterpublicprofiles : error : ' + error );
        }
    }); 
}

module.exports = new GroupChat();
