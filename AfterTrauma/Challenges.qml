import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "challenges"
    roles: [ "name", "activity", "repeats", "frequency", "values", "notes", "images", "notifications", "active", "date", "count" ]
    sort: { "name": 1 }
    //
    //
    //
    Component.onCompleted: {
        if ( false ) {//count <= 0 ) {
            console.log( 'generating challenge test data');
            //
            // test data
            //
            var data  = [
                        {
                            title: "Lying Back Excercise",
                            activity: "Lie on your back with both of your legs straight. In this position, bring your left knee up close to your chest. Hold this position for 10 seconds. Return your leg to the straight position. Repeat with the right leg.",
                            repeats: 5,
                            frequency: "morning and evening"
                        },
                        {
                            title: "Standing Back Excercise",
                            activity: "Stand up with your arms on your side. Bend to the left side while slowly sliding your left hand down your left leg. Come back up slowly and relax. Repeat with the right side of your body.",
                            repeats: 10,
                            frequency: "daily"
                        },
                        {
                            title: "Neck stretch up",
                            activity: "Keep your eyes centred on one object directly in front of you, now slowly move your head back. You will now be looking at the roof. Keep your whole body still. Hold this position for 5 seconds and slowly return your head to the start position.",
                            repeats: 3,
                            frequency: "hourly"
                        },
                        {
                            title: "Foot writing",
                            activity: "Barefooot write digits 1 to 10 using your toes raised up in the air.",
                            repeats: 1,
                            frequency: "weekly"
                        }
                    ];
            beginBatch();
            data.forEach(function(datum) {
                datum.count = 0;
                datum.date  = Date.now();
                datum.notifications = false;
                datum.active = false;
                batchAdd(datum);
            });
            endBatch();
            save();
        }
    }
    //
    //
    //
    function addChallenge(challenge) {
        challenge.count = 0;
        challenge.date = Date.now();
        add(challenge);
        save();
    }
    function updateChallenge(challenge) {
        var query = {_id:challenge._id};
        console.log( 'updating challenge : ' + JSON.stringify(query) );
        update(query,challenge);
        save();
    }
    function removeChallenge(challenge) {
        remove({_id:challenge._id});
        save();
    }
    function findChallenge(name) {
        var finds = find({name:name});
        return finds.length > 0 ? finds[0] : undefined;
    }
    function updateCount(index,count) {
        //
        // TODO: update daily count
        //
        var challenge = get(index);
        if ( challenge && challenge.count !== count ) {
            update({_id:challenge._id},{count:count});
            save();
        }
    }
}
