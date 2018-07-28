//
//
//
var jwt = require('jsonwebtoken');
//
//
//
const key = 'afterparty';
//
//
//
function Access() {
    
}

Access.prototype.sign = function( payload ) {
    return jwt.sign( payload, key);
}

Access.prototype.verify = function( token ) {
    return jwt.verify( token, key )
}

Access.prototype.verifyCommand = function( ws, command ) {
    if ( command.token ) {
        try {
            if ( jwt.verify( command.token, key ) ) {
                return true;
            }
            command.error = 'invalid token';    
         } catch( error ) {
             command.error = error;
         }
    } else {
        command.error = 'invalid token';    
    }
    command.status = 'ERROR';
    ws.send( JSON.stringify( command ) );
    return false;
}

module.exports = new Access();
