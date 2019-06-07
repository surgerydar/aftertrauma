/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
//
// passport authentication 
//
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');

module.exports = function( app, db ) {
    //
    //
    //
    passport.use('login', new LocalStrategy({ passReqToCallback : true },
        (req, username, password, callback)=>{
            console.log( 'authenticating : ' + username );
            db.findOne( 'users', { username: username }, { username: 1, password: 1, admin: 1 } ).then( (user) => {
                console.log( 'found user : ' + JSON.stringify(user) );
                if (!user) callback(null, false);
                if (user.admin !== 1) callback(null, false);
                if ( !bcrypt.compareSync(password, user.password) ) {
                    //
                    // update password
                    //
                    if (user.password !== password) {
                        callback(null, false);
                    } else {
                        db.updateOne('users',{username:username},{$set: { password: bcrypt.hashSync(password, 12)} } ).then( () => {
                            callback(null, user);
                        }).catch( () => {
                            callback(null, false);
                        })
                    }
                }
                callback(null, user);
            }).catch( ( error )=>{
                callback(error);
            });
        }));

    passport.serializeUser((user, callback)=>{
        console.log( 'serialising user');
        callback(null, user._id);
    });

    passport.deserializeUser((id, callback)=>{
         console.log( 'deserialising user');
        try {
            db.findOne('users', { _id:db.ObjectId(id) }, { username: 1, password: 1 } ).then( (user) => {
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
    app.get('/login', (req, res)=>{
        res.render('login');
    });
    app.post('/login', passport.authenticate('login', { failureRedirect: '/login', successRedirect: '/admin', }), (req, res)=>{
        res.redirect('/admin');
    });
    app.get('/logout', (req, res)=>{
        req.logout();
        res.redirect('/login');
    });
    //
    //
    //
    return (req, res, next)=>{
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
