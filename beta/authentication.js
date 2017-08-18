//var WebSocket = require('ws');
//
// TODO: move sketch session storage to db
//
function Authentication() {
}
/*
Authentication.prototype.processMessage = function( wss, ws, message ) {
    try {
        var command = JSON.parse( message );
        if ( command && this[ command.command ] ) {
            console.log( 'processing command : ' + command.command );
            this[ command.command ]( wss, ws, command );
        } else {
            console.log( 'Authentication.processMessage : unable to process message ' + message  );
        }
    } catch( err ) {
        console.log( 'Authentication.processMessage : ' + err + ' : unable to process message ' + message  );
    }
}
*/
var _db;

Authentication.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Authentication connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Authentication.prototype.register = function( wss, ws, command ) {
    console.log( 'Authentication.register : username:' + command.username + ' email:' + command.email + ' password:' + command.password );
    //
    // create user
    //
    var user = {
        username: command.username,
        email: command.email,
        password: command.password
    };
    
    process.nextTick(function(){   
        console.log('registering user : ' + JSON.stringify(user));
        _db.putUser(user).then(function( response ) {
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
Authentication.prototype.login = function( wss, ws, command ) {
    console.log( 'Authentication.login : username:' + command.username + ' password:' + command.password );
    //
    // create user
    //
    var user = {
        username: command.username,
        password: command.password
    };
    process.nextTick(function(){   
        console.log('authenticating user : ' + JSON.stringify(user));
        _db.validateUser(user).then(function( response ) {
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

module.exports = new Authentication();

