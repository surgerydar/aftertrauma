import QtQuick 2.0

import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    colour: Colours.lightGreen
    showNavigation: true
    validate: updateNotification
    //
    //
    //
    Flickable {
        anchors.fill: parent
        contentHeight: activityText.contentHeight + 32
        //
        //
        //
        AfterTrauma.Button {
            id: doneCheckbox
            height: 24
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16
            visible: active
            checkable: true
            textSize: 18
            text: checked ? "done" : "to do"
            backgroundColour: checked ? Colours.darkGreen : Colours.red
            onCheckedChanged: {
                challengeModel.updateCount( challengeId, checked ? repeats : 0, checked );
                var challenge = {
                    _id: challengeId,
                    name: title
                };
                var date = new Date();
                if ( checked ) {
                    dailyModel.addChallenge( date, challenge );
                } else {
                    dailyModel.removeChallenge( date, challenge );
                }
            }
        }
        //
        //
        //
        Text {
            id: activityText
            //anchors.fill: parent
            anchors.top: active ? doneCheckbox.bottom : parent.top
            width: parent.width
            anchors.margins: 4
            //
            //
            //
            color: Colours.almostWhite
            //
            //
            //
            padding: 8
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            //
            //
            //
            minimumPointSize: 12
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 24
        }
    }
    //
    //
    //
    footer: Rectangle {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        color: Colours.lightGreen
        //
        //
        //
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: notificationsSwitch.left
            anchors.rightMargin: 4
            color: Colours.almostWhite
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 18
            text: "Notifications"
        }
        AfterTrauma.Switch {
            id: notificationsSwitch
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: activeLabel.left
            anchors.rightMargin: 8
            onClicked: {
                challengeModel.update({_id:challengeId},{notifications:checked});
                challengeModel.save();
            }
        }
        Label {
            id: activeLabel
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: activeSwitch.left
            anchors.rightMargin: 4
            color: Colours.almostWhite
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 18
            text: "Active"
        }
        AfterTrauma.Switch {
            id: activeSwitch
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 4
            onClicked: {
                challengeModel.update({_id:challengeId},{active:checked});
                challengeModel.save();
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        doneCheckbox.checked = count >= repeats;
    }
    //
    //
    //
    function updateNotification() {
        challengeModel.updateNotification( challengeId );
        return true;
    }
    //
    //
    //
    property alias activity: activityText.text
    property alias active: activeSwitch.checked
    property alias notifications: notificationsSwitch.checked
    property int repeats: 0
    property int count: 0
    property string challengeId: ""
}
