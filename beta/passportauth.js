//
// passport authentication 
//
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;

module.exports = function( app, db ) {
    //
    //
    //
    passport.use('login',new LocalStrategy({ passReqToCallback : true },
        function(req, username, password, callback) {
            console.log( 'authenticating : ' + username );
            db.findOne( 'users', { username: username }, { username: 1, password: 1, admin: 1 } ).then( function(user) {
                console.log( 'found user : ' + JSON.stringify(user) );
                if (!user) callback(null, false);
                if (user.password !== password) callback(null, false);
                if (user.admin !== 1) callback(null, false);
                callback(null, user);
            }).catch( function( error ) {
                callback(error);
            });
        }));

    passport.serializeUser(function(user, callback) {
        console.log( 'serialising user');
        callback(null, user._id);
    });

    passport.deserializeUser(function(id, callback) {
         console.log( 'deserialising user');
        try {
            db.findOne('users', { _id:db.ObjectId(id) }, { username: 1, password: 1 } ).then( function(user) {
                callback(null, user);
            }).catch( function( error ) {
                callback( error );
            });
        } catch( error ) {
            callback( error );
        }
    });
    //
    // TODO: move these out of here, perhaps
    //
    app.use(require('cookie-parser')('unusual*windy'));
    app.use(require('express-session')({ secret: 'unusual*windy', resave: false, saveUninitialized: false }));
    //
    //
    //
	app.use(passport.initialize());
	app.use(passport.session());
    //
    // routes
    //
    app.get('/login', function(req, res){
        res.render('login');
    });
    app.post('/login', passport.authenticate('login', { failureRedirect: '/login', successRedirect: '/admin', }),  function(req, res) {
        res.redirect('/admin');
    });
    app.get('/logout', function(req, res){
        req.logout();
        res.redirect('/login');
    });
    //
    //
    //
    return function(req, res, next) {
        if ( req.user && req.isAuthenticated() ) {
            return next();
        } else {
            if( req.xhr ) {
                // ajax requests get a brief response
                console.log( 'rejecting xhr request' );
                res.status(401).json({ status : 'ERROR', message : 'no longer logged in' });
            } else {
                // all others are redirected to login
                console.log( 'redirecting to login' );
                res.redirect('/login');
            }
        }
    }
}
