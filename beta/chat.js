/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
//
// 
//
let _db;
let _live = [];
const jwt = require('jsonwebtoken');
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
            console.log( 'Chat removing live connection ' + _live[ i ].username );
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
//
//
//
function Chat() {
}

Chat.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Chat connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Chat.prototype.getuserchats = function( wss, ws, command ) {
    console.log( 'Chat.getuserchats : user id:' + command.id );
    //
    // add chat to db
    //
    process.nextTick(()=>{   
        if ( jwt.verify( command.token, 'afterparty' ) ) {
            _db.find('chats',{$or:[{to: command.id},{from: command.id}]}).then( ( response )=>{
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } else {
            command.status = 'ERROR';
            command.error = 'user not authenticated';
            ws.send(JSON.stringify(command));
        }
    }); 
}

Chat.prototype.sendinvite = function( wss, ws, command ) {
    console.log( 'Chat.sendinvite : from id:' + command.from + 'from username:' + command.fromUsername + ' to id:' + command.to + ' to username:' + command.toUsername );
    //
    // add chat to db
    //
    process.nextTick(()=>{   
        //console.log('updating user : ' + JSON.stringify(command.Chat));
        if ( jwt.verify( command.token, 'afterparty' ) ) {
            var chat = {
                id: command.id,
                from: command.from,
                fromUsername: command.fromUsername,
                to: command.to,
                toUsername: command.toUsername,
                status: "invite"
            };
            _db.putChat(chat).then( ( response )=>{
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
                //
                //
                //
                sendToLive(command.to,command);
            }).catch( ( error )=>{
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } else {
            command.status = 'ERROR';
            command.error = 'user not authenticated';
            ws.send(JSON.stringify(command));
        }
    }); 
}

Chat.prototype.acceptinvite = function( wss, ws, command ) {
    console.log( 'Chat.acceptinvite : from id:' + command.from + 'from username:' + command.fromUsername + ' to id:' + command.to + ' to username:' + command.toUsername );
    //
    // update chat status
    //
    process.nextTick(()=>{   
        if ( jwt.verify( command.token, 'afterparty' ) ) {
            _db.updateOne('chats', { id: command.id }, {$set:{status:"active"}}).then( ( response )=>{
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
                sendToLive( command.from, command );
            }).catch( ( error )=>{
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } else {
            command.status = 'ERROR';
            command.error = 'user not authenticated';
            ws.send(JSON.stringify(command));
        }
    }); 
}

Chat.prototype.removechat = function( wss, ws, command ) {
    console.log( 'Chat.removechat : from id:' + command.from + 'from username:' + command.fromUsername + ' to id:' + command.to + ' to username:' + command.toUsername );
    //
    // remove chat
    //
    process.nextTick(()=>{   
        if ( jwt.verify( command.token, 'afterparty' ) ) {
            _db.remove('chats', { id: command.id }).then( ( response )=>{
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
            }).catch( ( error )=>{
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } else {
            command.status = 'ERROR';
            command.error = 'user not authenticated';
            ws.send(JSON.stringify(command));
        }
    }); 
}

Chat.prototype.sendmessage = function( wss, ws, command ) {
    console.log( 'Chat.sendmessage : chat id:' + command.id + 'from id:' + command.from + ' message:' + command.message );
    //
    // update chat status
    //
    process.nextTick(()=>{   
        if ( jwt.verify( command.token, 'afterparty' ) ) {
            _db.updateOne('chats', { id: command.id }, {$push: { messages: { from: command.from, message: command.message } } }).then( ( response )=>{
                command.status = 'OK';
                command.response = response;
                ws.send(JSON.stringify(command));
                sendToLive( command.to, command );
            }).catch( ( error )=>{
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } else {
            command.status = 'ERROR';
            command.error = 'user not authenticated';
            ws.send(JSON.stringify(command));
        }
    }); 
}


Chat.prototype.golive = function( wss, ws, command ) {
    console.log( 'Chat.golive : id:' + command.id + ' username:' + command.username );
    //
    //
    //
    addToLive( command.id, command.username, ws );
    process.nextTick(()=>{
        command.status = 'OK';
        
    });
}

module.exports = new Chat();
