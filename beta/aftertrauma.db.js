/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
//
// database
//
const MongoClient = require('mongodb').MongoClient;
const ObjectId = require('mongodb').ObjectID;
const bcrypt = require('bcryptjs');

function Db() {
}

Db.prototype.connect = function( host, port, database, username, password ) {
	host 		= host || '127.0.0.1';
	port 		= port || '27017';
	database 	= database || 'aftertrauma';
	let authentication = username && password ? username + ':' + password + '@' : '';
	let url = host + ':' + port + '/' + database;
	console.log( 'connecting to mongodb://' + authentication + url );
	let self = this;
	return new Promise( ( resolve, reject )=>{
		try {
			MongoClient.connect('mongodb://'+ authentication + url, function(err, db) {
				if ( !err ) {
					console.log("Connected to database server");
					self.db = db;
                    //
                    //
                    //
					resolve( db );
				} else {
					console.log("Unable to connect to database : " + err);
					reject( err );
				}
			});
		} catch( err ) {
			reject( err );
		}
	});
}


Db.prototype.putUser = function( data ) {
    console.log( 'db.putUser : ' + JSON.stringify(data) );
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( 'users' ).findOne({$or: [ { id:data.id }, { username:data.username }, { email:data.email } ]},(err,user)=>{
                if ( user ) {
                    if ( user.id === data.id ) {
                        console.log( 'db.putUser : user id exists' );
                        reject( 'a user with this id is already registered' ); // this shouldn't happen
                    } else {
                        console.log( 'db.putUser : user exists' );
                        reject( 'user already registered with this email or password' );
                    }
                } else {
                    db.collection( 'users' ).insertOne(data,(err,result)=>{
                       if ( err ) {
                           console.log( 'db.putUser : error : ' + err );
                           reject( err );
                       } else {
                           console.log( 'db.putUser : ok' );
                           resolve( 'signed up' );
                       }
                    });
                }
            });
        } catch( err ) {
            console.log( 'db.putUser : error : exception : ' + err );
            console.log( err );
            reject( err );
        }
    });

}

Db.prototype.updateUser = function( id, user ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             if ( user._id ) user._id = undefined; // avoid conflicts
             //console.log( 'updating user with : ' + JSON.stringify(user) );
             db.collection('users').findOneAndUpdate( { id: id }, { $set: user }, ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.validateUser = function( data ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').findOne( {$and: [ { username:data.username }, { password:data.password } ]}, { password: 0 }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else if( result ) {
                    resolve( result );
                } else {
                    reject( { error: 'unable to find user : ' + data.username } );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.deleteUser = function( id ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').deleteOne( { id: id }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUser = function( id ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').findOne( { id: id }, { password: 0 }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else if( result ) {
                    resolve( result );
                } else {
                    reject( { error: 'unable to find user : ' + id } );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.findUsers = function( query, projection, sort ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').find(query,projection||{}).sort(sort||{}).toArray( function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else if( result ) {
                    resolve( result );
                } else {
                    reject( { error: 'unable to find users : ' + query } );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUserByEmail = function( email ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').findOne( { email: email }, { password: 0 }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.getUserByName = function( username ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').findOne( { username: username }, { password: 0 }, function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.getUserList = function() {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('users').find( {}, { username: 1, id: 1 }).sort({username:1}).toArray( ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    //
                    // TEMP: convert to new form { id: id, name: username }
                    //
                    let userlist = [];
                    result.forEach( function(user) {
                        userlist.push({
                            id: user.id,
                            name: user.username
                        });
                    } );
                    resolve( userlist );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.getGroupList = function() {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('entities').find( {type:'group'}, { name: 1, id: 1 }).sort({name:1}).toArray( ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
//
//
//

Db.prototype.putChat = function( chat ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( 'chats' ).insertOne(chat, (err,result)=>{
               if ( err ) {
                   reject( err );
               } else {
                   resolve( 'saved' );
               }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.updateChat = function( id, chat ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('chats').findOneAndUpdate( { id: id }, chat, ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.deleteChat = function( id ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( 'chats' ).deleteOne({id:id}, (err,result)=>{
               if ( err ) {
                   reject( err );
               } else {
                   resolve( 'deleted' );
               }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.getChat = function( id ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection('chats').findOne( { id: id }, ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.findChats = function( query, order, sort ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection('chats').find(query).sort(sort||{}).toArray( ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                     resolve( result );
                }
            });  
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
//
// Days
//
Db.prototype.putDay = function( day ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( 'days' ).insertOne(daily, (err,result)=>{
               if ( err ) {
                   reject( err );
               } else {
                   resolve( 'saved' );
               }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.updateDay = function( id, day ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection( 'days' ).findOneAndUpdate( { id: id }, day, ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.deleteDay = function( id ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( 'days' ).deleteOne({id:id}, (err,result)=>{
               if ( err ) {
                   reject( err );
               } else {
                   resolve( 'deleted' );
               }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.getDay = function( id ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection( 'days' ).findOne( { id: id }, ( err, result )=>{
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}
Db.prototype.findDays = function( query, projection, order, limit ) {
    return this.find( 'days', query, projection, order, limit );
}
//
// generic function
//
Db.prototype.drop = function( collection ) {
	let db = this.db;
	return new Promise( ( resolve, reject )=>{
		try {
			db.collection( collection ).drop( (err,result)=>{
				if ( err ) {
                    console.log( 'drop : ' + collection + ' : error : ' + err );
					reject( err );
				} else {
					resolve( result );
				}
			});
		} catch( err ) {
            console.log( 'drop : ' + collection + ' : error : ' + err );
			reject( err );
		}
	});
}

Db.prototype.insert = function( collection, document ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( collection ).insertOne( document, (err,result)=>{
               if ( err ) {
                   console.log( 'insert : ' + collection + ' : error : ' + err );
                   reject( err );
               } else {
                   resolve( result );
               }
            });
        } catch( err ) {
            console.log( 'insert : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.remove = function( collection, query ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( collection ).remove( query, (err,result)=>{
               if ( err ) {
                   console.log( 'remove : ' + collection + ' : error : ' + err );
                   reject( err );
               } else {
                   resolve( result );
               }
            });
        } catch( err ) {
            console.log( 'remove : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.updateOne = function( collection, query, update ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
         try {
             db.collection( collection ).findOneAndUpdate( query, update, { returnNewDocument: true }, ( err, result )=>{
                if ( err ) {
                    console.log( 'update : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( 'update : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.find = function( collection, query, projection, order, limit ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection( collection ).find(query||{},projection||{}).sort(order||{}).limit(limit||0).toArray( ( err, result )=>{
                if ( err ) {
                    console.log( 'find : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
            });  
        } catch( err ) {
            console.log( 'find : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.findOne = function( collection, query, projection ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection(collection).findOne(query,projection||{}, ( err, result )=>{
                if ( err ) {
                    console.log( 'findOne : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.findAndModify = function( collection, query, sort, update, options ) {
    let db = this.db;
    return new Promise( ( resolve, reject )=>{
        try {
            db.collection(collection).findAndModify( query, sort, update, options, ( err, result )=>{
                if ( err ) {
                    console.log( 'findAndModify : ' + collection + ' : error : ' + err + ' : param : ' + JSON.stringify(document) );
                    reject( err );
                } else {
                    resolve( result );
                }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}


Db.prototype.ObjectId = function( hex ) {
    return new ObjectId.createFromHexString(hex);
}
module.exports = new Db();

