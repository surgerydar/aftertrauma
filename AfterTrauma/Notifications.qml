import QtQuick 2.6

ListModel {
    id: model

    Component.onCompleted: {
        console.log( 'Notifications : starting update timer' );
        notificationTimer.start();
    }
    //
    //
    //
    signal updated()
    //
    //
    //
    function update() {
        //
        // questionnaires
        //
        if(!questionnaireModel.dailyCompleted()) {
            if ( !findNotification("questionnaire") ) {
                console.log( 'Notifications : adding questionnaire prompt' );
                append({subject:"questionnaire", text:"don't forget to complete your daily questionnaire"});
                NotificationManager.scheduleNotification(questionnaire_base_id, "don't forget to complete the questionnaire", 0, 60000);
                updated();
            }
        } else {
            removeNotification("questionnaire");
            NotificationManager.cancelNotification(questionnaire_base_id);
            updated();
        }
        //
        // challenges
        //

        //
        // motivational
        //

    }
    function findNotification( subject ) {
        var nNotifications = model.count;
        for ( var i = 0; i < nNotifications; i++ ) {
            var notification = get(i);
            if ( notification.subject === subject ) {
                return notification;
            }
        }
        return undefined;
    }
    function removeNotification( subject ) {
        var nNotifications = model.count;
        for ( var i = 0; i < nNotifications; i++ ) {
            var notification = get(i);
            if ( notification.subject === subject ) {
                model.remove(i);
                return;
            }
        }
    }
    //
    //
    //
    property int questionnaire_base_id: 102
    property int chat_base_id: 103
    property int challenge_base_id: 104
}
