import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "prescriptions"
    roles: [ "id", "date", "image", "goals" ]
    sort: { "date": -1 }
    //
    //
    //
    Component.onCompleted: {
        //
        // test data
        //
        if ( false ) { //count <= 0 ) {
            beginBatch();
            for ( var i = 0 ;i < 3; i++ ) {
                var p = {
                    id: GuidGenerator.generate(),
                    date: Date.now(),
                    image: "image0.jpg",
                    goals: [
                        { name: 'emotions', value: 1.0 },
                        { name: 'confidence', value: 1.0 },
                        { name: 'body', value: 1.0 },
                        { name: 'life', value: 1.0 },
                        { name: 'relationships', value: 1.0 }
                    ]
                };
                batchAdd(p);
            }
            endBatch();
            save();
        }
    }

}
