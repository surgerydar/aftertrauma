//
// database
//
var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var bcrypt = require('bcryptjs');

function Db() {
}

Db.prototype.connect = function( host, port, database, username, password ) {
	host 		= host || '127.0.0.1';
	port 		= port || '27017';
	database 	= database || 'aftertrauma';
	var authentication = username && password ? username + ':' + password + '@' : '';
	var url = host + ':' + port + '/' + database;
	console.log( 'connecting to mongodb://' + authentication + url );
	var self = this;
	return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'users' ).findOne({$or: [ { id:data.id }, { username:data.username }, { email:data.email } ]},function(err,user) {
                if ( user ) {
                    if ( user.id === data.id ) {
                        console.log( 'db.putUser : user id exists' );
                        reject( 'a user with this id is already registered' ); // this shouldn't happen
                    } else {
                        console.log( 'db.putUser : user exists' );
                        reject( 'user already registered with this email or password' );
                    }
                } else {
                    db.collection( 'users' ).insertOne(data,function(err,result) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').findOneAndUpdate( { id: id }, user, function( err, result ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('users').find( {}, { username: 1, id: 1 }).sort({username:1}).toArray( function( err, result ) {
                if ( err ) {
                    console.log( err );
                    reject( err );
                } else {
                    //
                    // TEMP: convert to new form { id: id, name: username }
                    //
                    var userlist = [];
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('entities').find( {type:'group'}, { name: 1, id: 1 }).sort({name:1}).toArray( function( err, result ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'chats' ).insertOne(chat,function(err,result) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('chats').findOneAndUpdate( { id: id }, chat, function( err, result ) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'chats' ).deleteOne({id:id},function(err,result) {
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
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('chats').findOne( { id: id }, function( err, result ) {
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
Db.prototype.findChats = function( query, order ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection('chats').find(query).sort(sort||{}).toArray( function( err, result ) {
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
// TODO: replace entities with specific collections
//
Db.prototype.putEntity = function( entity ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'entities' ).insertOne(entity,function(err,result) {
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
Db.prototype.updateEntity = function( id, entity ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('entities').findOneAndUpdate( { id: id }, entity, function( err, result ) {
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
Db.prototype.deleteEntity = function( id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            db.collection( 'entities' ).deleteOne({id:id},function(err,result) {
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
Db.prototype.getEntity = function( id ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('entities').findOne( { id: id }, function( err, result ) {
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
Db.prototype.getUserEntities = function( userId, type, order ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            var query = {$and:[{userId:userId},{type:type}]};
            var sort = {};
            if ( order ) {
                sort = order;
            }
            db.collection('entities').find(query).sort(sort).toArray( function( err, result ) {
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
Db.prototype.findUserEntities = function( userId, type, filter, order ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            //
            //
            //
            var query = {}; 
            if ( filter && filter.length > 0 ) {
                query = {$and:[{userId:userId},{type:type},{ $text: { $search: filter } }]};
            } else {
                query = {$and:[{userId:userId},{type:type}]};
            }
            var sort = {};
            if ( order ) {
                sort = order;
            }
            db.collection('entities').find(query).sort(sort).toArray( function( err, result ) {
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
Db.prototype.findUserConversations = function( userId, privacy, filter ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            //
            //
            //
            var query = privacy === 'public' ? {privacy:'public'} : {$or:[{userId:userId},{fromid:userId},{toid:userId}]}; 
            if ( filter && filter.length > 0 ) {
                query = {$and:[query,{type:'conversation'},{ $text: { $search: filter } }]};
            } else {
                query = {$and:[query,{type:'conversation'}]};
            }
            db.collection('entities').find(query).toArray( function( err, result ) {
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
Db.prototype.updateConversation = function( id, snippet ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
         try {
             db.collection('entities').findOneAndUpdate( { id: id }, { $push: { snippets: snippet } }, function( err, result ) {
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
/*
Db.prototype.findUsers = function( filter ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            //
            //
            //
            var query = filter ? { $text: { $search: filter } } : {};
            db.collection('users').find(query,{ password: 0 }).sort({username:1}).toArray( function( err, result ) {
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

Db.prototype.findUserGroups = function( userId, filter ) {
    var db = this.db;
    return new Promise( function( resolve, reject ) {
        try {
            //
            //
            //
            var query = {type:'group'};
            if( userId ) {
                query = {$and:[{type:"group"},{members:{$elemMatch: {id:userId}}}]};
            }
            if ( filter && filter.length > 0 ) {
                query = {$and:[query,{ $text: { $search: filter } }]};
            }
            db.collection('entities').find(query).toArray( function( err, result ) {
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
*/
//
//
//
Db.prototype.drop = function( collection ) {
	var db = this.db;
	return new Promise( function( resolve, reject ) {
		try {
			db.collection( collection ).drop(function(err,result) {
				if ( err ) {
					reject( err );
				} else {
					resolve( result );
				}
			});
		} catch( err ) {
			reject( err );
		}
	});
}


module.exports = new Db();

