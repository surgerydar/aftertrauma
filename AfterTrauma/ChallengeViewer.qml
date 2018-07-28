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
    Text {
        id: activityText
        anchors.fill: parent
        anchors.margins: 4
        color: Colours.almostWhite
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        minimumPixelSize: 14
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 32
    }
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
    function updateNotification() {
        //
        //
        //
        challengeModel.updateNotification( challengeId );
        return true;
    }
    //
    //
    //
    property alias activity: activityText.text
    property alias active: activeSwitch.checked
    property alias notifications: notificationsSwitch.checked
    property string challengeId: ""
}
