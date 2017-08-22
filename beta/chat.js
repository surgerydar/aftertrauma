//
// 
//
var _db;
var _live = [];
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

Chat.prototype.sendinvite = function( wss, ws, command ) {
    console.log( 'Chat.sendinvite : from id:' + command.from + 'from username:' + command.fromUsername + ' to id:' + command.to + ' to username:' + command.toUsername );
    //
    // add chat to db
    //
    process.nextTick(function(){   
        //console.log('updating user : ' + JSON.stringify(command.Chat));
        var chat = {
            id: command.id,
            from: command.from,
            fromUsername: command.fromUsername,
            to: command.to,
            toUsername: command.toUsername,
            status: "pending"
        };
        _db.putChat(chat).then(function( response ) {
            command.status = 'OK';
            command.response = response;
            ws.send(JSON.stringify(command));
            //
            //
            //
            sendToLive(command.to,command);
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    }); 
    //
    // relay
    //
    
}

Chat.prototype.acceptinvite = function( wss, ws, command ) {
    console.log( 'Chat.acceptinvite : from id:' + command.from + 'from username:' + command.fromUsername + ' to id:' + command.to + ' to username:' + command.toUsername );
    //
    // update chat status
    //
    process.nextTick(function(){   
        //console.log('updating user : ' + JSON.stringify(command.Chat));
        var chat = {
            status: "active"
        };
        _db.updateChat(command.id,chat).then(function( response ) {
            command.status = 'OK';
            command.response = response;
            ws.send(JSON.stringify(command));
            sendToLive( command.from, command );
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    }); 
}

Chat.prototype.golive = function( wss, ws, command ) {
    console.log( 'Chat.golive : id:' + command.id + ' username:' + command.username );
    //
    //
    //
    addToLive( command.id, command.username, ws );
}

module.exports = new Chat();
