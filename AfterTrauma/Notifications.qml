import QtQuick 2.6

ListModel {
    id: model

    Component.onCompleted: {
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
        if(!questionnaireModel.dailyCompleted()) {
            if ( !findNotification("questionnaire") ) {
                model.append({subject:"questionnaire", text:"don't forget to complete your daily questionnaire"});
                updated();
            }
        } else {
            removeNotification("questionnaire");
            updated();
        }
    }
    function findNotification( subject ) {
        var nNotifications = model.count;
        for ( var i = 0; i < nNotifications; i++ ) {
            var notification = model.get(i);
            if ( notification.subject === 'questionnaire' ) {
                return notification;
            }
        }
        return undefined;
    }
    function removeNotification( subject ) {
        var nNotifications = model.count;
        for ( var i = 0; i < nNotifications; i++ ) {
            var notification = model.get(i);
            if ( notification.subject === 'questionnaire' ) {
                model.remove(i);
                return;
            }
        }
    }

}
