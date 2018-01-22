//
// 
//
var _db;

function Sync() {
}

Sync.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Sync connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Sync.prototype.categories = function( wss, ws, command ) {
    console.log( 'Sync.categories : date:' + command.date );
    //
    // update user
    //
    process.nextTick(function(){   
        let query = {
            date: { $gt: command.date || 0 }
        };
        _db.find( 'category', query ).then( function( response ) {
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

Sync.prototype.manifest = function( wss, ws, command ) {
    console.log( 'Sync.manifest : date:' + command.date );
    //
    // update user
    //
    process.nextTick(function(){   
        let query = {
            date: { $gt: command.date || 0 }
        };
        _db.find( 'delta', query ).then( function( response ) {
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

Sync.prototype.documents = function( wss, ws, command ) {
    console.log( 'Sync.documents : date:' + command.date );
    //
    // update user
    //
    process.nextTick(function(){   
        let query = {
            date: { $gt: command.date || 0 }
        };
        _db.find( 'document', query ).then( function( response ) {
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

module.exports = new Sync();

