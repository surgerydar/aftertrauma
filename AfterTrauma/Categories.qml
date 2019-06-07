import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "categories"
    roles: [ 'category', 'section', 'title', 'date', 'index' ]
    sort: { "index": 1 }
    //
    //
    //
    Component.onCompleted: {
    }
}
