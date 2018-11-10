//
// 
//
var _db;

function Usage() {
    
}

Usage.prototype.setup = function( wsr, db ) {
    _db = db;
    for ( var key in this ) {
        if ( key !== 'setup' && typeof this[ key ] === 'function' ) {
            console.log( 'Usage connecting : ' + key );
            wsr.json( key, this[ key ] );
        }
    }
}

Usage.prototype.usagesyncrequest = function( wss, ws, command ) {
    console.log( 'Usage.usagesyncrequest : id:' + command.usageid );
    //
    // get latest usage entry for usageid
    //
    process.nextTick(function(){ 
        _db.find( 'usage', {usageid: command.usageid}, {date:1}, {date:-1}, 1 ).then(function(response) {
            command.status = 'OK';
            command.response = response.length > 0 ? response[0].date : 0;
            ws.send(JSON.stringify(command));
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    }); 
}

Usage.prototype.usagesync = function( wss, ws, command ) {
    console.log( 'Usage.usagesync : id :' + command.usageid );
    //
    // insert usage entries for usageid
    //
    process.nextTick(function() { 
        command.usage.forEach( function( entry ) {
            entry.usageid = command.usageid;
            if ( entry._id ) delete entry._id; // avoid conflicts
            //
            //
            //
            _db.insert( 'usage', entry ).then( function(result) {
                
            }).catch( function(error) {
                console.log( 'Usage.usagesync : error inserting : ' + JSON.stringify( entry ) )
            });
        } );
        ws.send(JSON.stringify({command:command,status:'OK'}));
    }); 
}

module.exports = new Usage();

