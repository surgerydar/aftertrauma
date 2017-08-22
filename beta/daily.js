//
// 
//
var _db;

function Daily() {
}

Daily.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Daily connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Daily.prototype.updateDaily = function( wss, ws, command ) {
    console.log( 'Daily.updateDaily : id:' + command.userId );
    //
    // update user
    //
    process.nextTick(function(){   
        //console.log('updating user : ' + JSON.stringify(command.Daily));
        _db.updateUser(command.Daily.id,command.Daily).then(function( response ) {
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

Daily.prototype.getpublicDailys = function( wss, ws, command ) {
    console.log( 'Daily.getpublicDailys : exclude:' + command.exclude );
    //
    // update user
    //
    process.nextTick(function() {  
        let query = {};
        if ( command.exclude ) {
            query.id = { $not:command.exclude };
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

module.exports = new Daily();

