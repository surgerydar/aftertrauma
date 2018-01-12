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
        return new Promise( function( resolve, reject ) {
            try {
                db.findAndModify( 'delta', 
                                 query, // query
                                 [], // sort
                                 { $set: update }, // update
                                 { upsert: true, new: true } // options
                                ).then( function( response ) {
                    resolve( response );
                }).catch( function( error ) {
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
        addDocument: function( section, category, document, title ) {
            return updateDocument( section, category, document, title, 'add' );
        },
        updateDocument: function( section, category, document, title ) {
            return updateDocument( section, category, document, title, 'edit' );
        },
        removeDocument: function( section, category, document ) {
            return updateDocument( section, category, document, undefined, 'remove' );
        },
        getManifest: function( afterDate ) {
            let query = {
                date: { $lt: ( afterDate > 0 ? afterDate : Date.now() ) }
            };
            return new Promise( function( resolve, reject ) {
                try {
                    db.find( 'delta', query ).then( function( response ) {
                        resolve( response );
                    }).catch( function ( error ) {
                        reject( error );
                    });
                } catch( error ) {
                    reject( error );
                }
            });
        }
    };
}
