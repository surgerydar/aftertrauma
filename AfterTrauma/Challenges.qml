import QtQuick 2.7
import SodaControls 1.0
import "utils.js" as Utils

DatabaseList {
    id: model
    collection: "challenges"
    roles: [ "_id", "name", "activity", "repeats", "frequency", "values", "notes", "images", "notifications", "active", "date", "count" ]
    sort: { "active": -1 }//, "name": 1 }
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
        console.log( "adding challenge : " + JSON.stringify(challenge) );
        challenge.count = 0;
        challenge.date = Date.now();
        challenge.active = challenge.active || false;
        challenge._id = add(challenge)._id;
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
        return findOne({name:name});
    }
    function updateCount(id,count) {
        //
        // TODO: update daily count
        //
        /*
        var challenge = get(index);
        if ( challenge && challenge.count !== count ) {
            update({_id:challenge._id},{count:count});
            save();
        }
        */
        console.log('Challenges.updateCount : ' + id + ' : count : ' + count );
        var updated  = update({_id:id},{count:count});
        console.log('Challenges.updateCount : updated : ' + updated );

        save();
    }
    function updateNotification(id) {
        //
        //
        //
        var challenge  = challengeModel.findOne({_id:id});
        if ( challenge && challenge.active && challenge.notifications ) {
            if ( !challenge.notificationId ) {
                challenge.notificationId = generateNotificationId(id);
                challengeModel.update({_id:id},{notificationId:challenge.notificationId});
                challengeModel.save();
            }
            var patterns = {
                "hourly": 0,
                "fourtimesdaily": 1,
                "morningandevening": 2,
                "daily": 3,
                "weekly": 4
            };
            var frequency = challenge.frequency.replace(/\s+/g, '').toLowerCase();
            var pattern = patterns[ frequency ] === undefined ? 5 : patterns[ frequency ];
            NotificationManager.scheduleNotificationByPattern(notificationType,challenge.notificationId,challenge.name,pattern);
        } else if( challenge.notificationId ) {
            NotificationManager.cancelNotificationByPattern(notificationType,challenge.notificationId);
            challengeModel.update({_id:id},{notificationId:0});
            challengeModel.save();
        }
    }
    function showNotifiedChallenge( notificationId ) {
        console.log( 'Challenges.showNotifiedChallenge : ' + notificationId );
        var challenge = findOne({notificationId:notificationId});
        if ( challenge ) {
            var properties = {
                title: challenge.name,
                activity: Utils.formatChallengeDescription(challenge.activity, challenge.repeats, challenge.frequency),
                active: challenge.active,
                notifications: challenge.notifications,
                challengeId: challenge._id,
                repeats: challenge.repeats
            };
            stack.push( "qrc:///ChallengeViewer.qml", properties );
        } else {
            stack.navigateTo( "qrc:///ChallengeManager.qml" );
        }
    }
    function generateNotificationId(id) {
        var notificationId = 0;
        var challenge;
        do {
            notificationId++;
            challenge = findOne( { $and: [ { _id: { $ne: id } }, { notificationId: notificationId } ] } );
        } while( challenge !== undefined );
        return notificationId;
    }
    //
    //
    //
    function viewChallenge( id ) {
        var challenge  = findOne({_id:id});
        if ( challenge ) {
            var properties = {
                title: challenge.name,
                activity: Utils.formatChallengeDescription(challenge.activity, challenge.repeats, challenge.frequency),
                active: challenge.active,
                notifications: challenge.notifications,
                challengeId: challenge._id,
                repeats: challenge.repeats
            };
            stack.push( "qrc:///ChallengeViewer.qml", properties );
        }
    }
    //
    //
    //
    property int notificationType: 0x2
}
