//
// 
//
var _db;

function Authentication() {
}

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
        id: command.id,
        username: command.username,
        email: command.email,
        password: command.password,
        avatar: "",
        profile: "",
        tags: []
    };
    process.nextTick(function(){   
        console.log('registering user : ' + JSON.stringify(user));
        _db.putUser(user).then(function( response ) {
            command.status = 'OK';
            command.response = { // TODO: findout why putUser is adding _id to user
                id: command.id,
                username: user.username,
                email: user.email,
                password: user.password,
                avatar: user.avatar,
                profile: user.profile,
                tags: user.tags
            };
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
            //
            // filter response
            // TODO: should probably happen in the db call use projection to exclude password
            //
            user.id = response.id;
            user.email = response.email;
            user.avatar = response.avatar;
            user.profile = response.profile;
            user.tags = response.tags;
            command.status = 'OK';
            command.response = user;
            ws.send(JSON.stringify(command));
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    });
}

module.exports = new Authentication();

