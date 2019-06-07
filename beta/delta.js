/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
module.exports = function( db ) {
    //
    //
    //
    console.log( 'initialising delta logging' );
    function updateDocument( section, category, document, title, operation ) {
        let query = { document: document, category: category, section: section };
        let update = { date: Date.now(), operation: operation };
        if ( title ) {
            update.title = title;
        }
        console.log( 'updating document delta : ' + JSON.stringify( update ) );
        return new Promise( ( resolve, reject )=> {
            try {
                db.findAndModify( 'delta', 
                                 query, // query
                                 [], // sort
                                 { $set: update }, // update
                                 { upsert: true, new: true } // options
                                ).then( ( response )=>{
                    resolve( response );
                }).catch( ( error )=>{
                    reject( error );
                });
            } catch( error ) {
                reject( error );
            }
        } );
    }
	function updateChallenge( challenge, operation ) {
        let query = { challenge: challenge };
        let update = { date: Date.now(), operation: operation };
        console.log( 'updating challenge delta : ' + JSON.stringify( update ) );
        return new Promise( ( resolve, reject )=>{
            try {
                db.findAndModify( 'delta', 
                                 query, // query
                                 [], // sort
                                 { $set: update }, // update
                                 { upsert: true, new: true } // options
                                ).then( ( response )=>{
                    resolve( response );
                }).catch( ( error )=>{
                    reject( error );
                });
            } catch( error ) {
                reject( error );
            }
        } );
	}
    //
    //
    //
    console.log( 'initialising delta object' );
    return {
        addDocument: ( section, category, document, title )=>{
            return updateDocument( section, category, document, title, 'add' );
        },
        updateDocument: ( section, category, document, title )=>{
            return updateDocument( section, category, document, title, 'edit' );
        },
        removeDocument: ( section, category, document )=>{
            return updateDocument( section, category, document, undefined, 'remove' );
        },
        addChallenge: ( challenge )=>{
            return updateChallenge( challenge, 'add' );
        },
        updateChallenge: ( challenge )=>{
            return updateChallenge( challenge, 'edit' );
        },
        removeChallenge: ( challenge )=>{
            return updateChallenge( challenge, 'remove' );
        },
        getManifest: ( afterDate )=>{
            let query = {
                date: { $lt: ( afterDate > 0 ? afterDate : Date.now() ) }
            };
            return new Promise( ( resolve, reject )=>{
                try {
                    db.find( 'delta', query ).then( ( response )=>{
                        resolve( response );
                    }).catch( ( error )=>{
                        reject( error );
                    });
                } catch( error ) {
                    reject( error );
                }
            });
        }
    };
}
