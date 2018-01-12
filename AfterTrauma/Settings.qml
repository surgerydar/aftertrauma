import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "aftertrauma"
    roles: [ "name", "value" ]
    sort: { "name": 1 }
    //
    //
    //
    Component.onCompleted: {
        if ( count <= 0 ) {
            //
            // test data
            //
            var data  = [
                        {
                            name: "firstrun",
                            value: false
                        },
                        {
                            name: "registered",
                            value: false
                        },
                        {
                            name: "lastupdate",
                            value: 0
                        }
                    ];
                data.forEach(function(datum) {
                    model.add(datum);
                });
            save();
        }
    }

}
