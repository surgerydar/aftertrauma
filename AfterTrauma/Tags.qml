import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "tags"
    roles: [ 'tag', 'documents' ]
    sort: { "tag": 1 }
    //
    //
    //
    function updateTag( tag, document ) {
        console.log( 'adding tag : ' + tag + ' : document : ' + document );
        var tagEntry = findOne( { tag: tag } );
        if ( tagEntry ) {
            console.log( 'updating tag : ' + tag + ' : document : ' + document );
            if ( tagEntry.documents.indexOf( document ) < 0 ) {
                tagEntry.documents.push( document );
                update( {tag: tag}, tagEntry );
            }
        } else {
            console.log( 'adding tag : ' + tag + ' : document : ' + document );
            tagEntry = {
                tag: tag,
                documents: [ document ]
            };
            add(tagEntry);
        }
    }
}
