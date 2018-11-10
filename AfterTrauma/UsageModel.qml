import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "usage"
    roles: [ "date", "section", "action", "item", "extra" ]
}
