import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "messages"
    roles: [ "id", "date", "from", "message", "blocked" ]
    sort: { "date": 1 }
}
