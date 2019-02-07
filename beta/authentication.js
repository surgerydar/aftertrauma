//
// 
//
var _db;
var access = require('./access');
var mailer = require('./mailer');
//
//
//
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
    // create new user
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
        _db.findOne('users', { $or: [{username: user.username},{email:user.email}] } ).then( function( response ) {
            if ( response === null ) {
                _db.insert('users', user ).then(function( response ) {
                    //
                    //
                    //
                    console.log( 'inserted: ' + JSON.stringify(user) + ' : response:' + JSON.stringify(response) );
                    command.status = 'OK';
                    command.response = { 
                        id: command.id,
                        username: user.username,
                        email: user.email,
                        //password: user.password, // JONS: password should not be returned
                        avatar: user.avatar,
                        profile: user.profile,
                        tags: user.tags,
                        token: access.sign({ user: command.username })
                    };
                    ws.send(JSON.stringify(command));
                }).catch(function(error){
                    command.status = 'ERROR';
                    command.error = error;
                    ws.send(JSON.stringify(command));
                });
            } else {
                command.status = 'ERROR';
                command.error  = 'A user with that name or email already exists';
                ws.send(JSON.stringify(command));
            }
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
    // find user
    //
    process.nextTick(function(){   
        _db.findOne('users', {$and: [ { username:command.username }, { password:command.password } ]}, { password: 0, _id: 0 } ).then(function( response ) {
            if ( response === null ) {
                command.status = 'ERROR';
                command.error = 'username or password incorrect';
            } else {
                if ( false ) { // JONS: disabled for this release response.blocked ) {
                    command.status = 'ERROR';
                    command.error = 'you have been blocked, please contact administrator';
                } else {
                    //
                    //
                    //
                    command.status = 'OK';
                    response.token = access.sign({ user: command.username });
                    command.response = response;
                }
            }
            //console.log('authentications response : ' + JSON.stringify( command ) );
            ws.send(JSON.stringify(command));
        }).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send(JSON.stringify(command));
        });
    });
}

Authentication.prototype.changepassword = function( wss, ws, command ) {
    //
    // 
    //
    console.log( 'Authentication.changepassword : username:' + command.username + ' old:' + command.oldpass + ' new:' + command.newpass );
    //
    // find and update user
    //
    process.nextTick(function(){
        if ( access.verifyCommand(ws,command) ) {
            _db.updateOne('users', {$and: [ { username:command.username }, { password:command.oldpass } ]}, { $set: { password: command.newpass } } ).then(function( response ) {
                if ( response === null || response.value === null ) {
                    command.status = 'ERROR';
                    command.error = 'username or password incorrect';
                    ws.send(JSON.stringify(command));
                } else {
                    //
                    // create new command to avoid sending both passwords back
                    //
                    console.log( 'Authentication.prototype.changepassword : response : ' + JSON.stringify( response ) );
                    ws.send(JSON.stringify({
                        command : 'changepassword',
                        status : 'OK'
                    }));
                }
                
            }).catch( function( error ) {
                command.status = 'ERROR';
                command.error = error;
                ws.send(JSON.stringify(command));
            });
        } 
    });
}

Authentication.prototype.resetpassword = function( wss, ws, command ) {
    //
    // 
    //
    console.log( 'Authentication.resetpassword : username or email:' + command.identifier );
    //
    // find user
    //
    process.nextTick(function(){
        //
        // TODO: replace this and move to somewhere more sensible
        //
        let randomPassword = function(length) {
            var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP1234567890";
            var pass = "";
            for (var x = 0; x < length; x++) {
            var i = Math.floor(Math.random() * chars.length);
                pass += chars.charAt(i);
            }
            return pass;
        };
        //
        //
        //
        let password = randomPassword( 8 );
        _db.updateOne( 'users', { $or: [ { username: command.identifier }, { email: command.identifier } ] }, { $set: { password: password } } ).then( function( response ) {
            if ( response ) {
                let username = response.username || response.value.username;
                let address = response.email || response.value.email;
                let message = 'Hi ' + username + ' your AfterTrauma password has been reset to <br/><b>' + password + '</b><br/>go to About Me to replace it with something more memorable'; 
                mailer.send( address, 'AfterTrauma - password reset', message ).then( function( response ) {
                    command.status = 'OK';
                    command.response = 'A temporary password has been sent to ' + address + ' please check your mailbox';
                    ws.send( JSON.stringify(command) );
                }).catch( function( error ) {
                    command.status = 'ERROR';
                    command.error = error;
                    ws.send( JSON.stringify(command) );
                });
            } else {
                command.status = 'ERROR';
                command.error = 'unable to find user with name or email ' + command.identifier;
                ws.send( JSON.stringify(command) );
            }
        } ).catch( function( error ) {
            command.status = 'ERROR';
            command.error = error;
            ws.send( JSON.stringify(command) );
        } );
    });
}


module.exports = new Authentication();

