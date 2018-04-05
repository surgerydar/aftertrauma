import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "bodyparts"
    roles: [ "name", "canonical", "selected" ]
    //sort: { "name": 1 }
    //
    //
    //
    Component.onCompleted: {
        if ( count <= 0 ) {
            console.log( 'generating body part data');
            //
            // test data
            //
            var data  = [
                {
                    name: "Head",
                    canonical: "head"
                },
                {
                    name: "Neck",
                    canonical: "neck"
                },
                {
                    name: "Back",
                    canonical: "back"
                },
                {
                    name: "Chest/Ribs",
                    canonical: "chest_ribs"
                },
                {
                    name: "Stomach",
                    canonical: "stomach"
                },
                {
                    name: "Pelvis",
                    canonical: "pelvis"
                },
                {
                    name: "Arm",
                    canonical: "arm"
                },
                {
                    name: "Leg/Hip",
                    canonical: "leg_hip"
                },
                {
                    name: "Other",
                    canonical: "other"
                }
            ];
            beginBatch();
            data.forEach(function(datum) {
                datum.selected = false;
                batchAdd(datum);
            });
            endBatch();
            save();
        }
    }
    //
    //
    //
    function setSelected(canonical,selected) {
        update({canonical:canonical},{selected:selected});
        save();
    }
}
