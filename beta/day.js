/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
//
// 
//
let _db;

function Day() {
}

Day.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Day connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Day.prototype.updateday = function( wss, ws, command ) {
    console.log( 'Day.updateday : id:' + command.userId );
    //
    // update day
    //
    process.nextTick(()=>{   
        //console.log('updating user : ' + JSON.stringify(command.Day));
        _db.updateUser(command.Day.id,command.Day).then( ( response )=>{
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

module.exports = new Day();

