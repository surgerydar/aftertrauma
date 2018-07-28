//var WebSocket = require('ws');
//
//
function Validator() {
}

Validator.prototype.setup = function( wsr, db ) {
    this.db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Validator connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Validator.prototype.validate = function( wss, ws, command ) {
    console.log( 'Validator.validate : field:' + command.field + ' criterion:' + command.criterion + ' content:' + command.content );
    //
    // validate
    //

    //
    // return status OK | INVALID | ERROR
    //
    command.status = 'OK';
    ws.send(JSON.stringify(command));
}

module.exports = new Validator();

