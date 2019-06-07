import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "documents"
    roles: [ 'document', 'category', 'title', 'blocks', 'date', 'index' ]
    sort: { "index": 1 }
    //
    //
    //
    Component.onCompleted: {
    }
}
