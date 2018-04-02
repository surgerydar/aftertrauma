import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 64
    //
    //
    //
    AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.darkPurple
    }
    //
    //
    //
    Image {
        id: avatarImage
        width: height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 8
        //
        //
        //
        fillMode: Image.PreserveAspectFit
        //
        //
        //
        source: "icons/profile_icon.png"
    }
    //
    //
    //
    Text {
        id: withUsernameText
        anchors.top: parent.top
        anchors.left: avatarImage.right
        anchors.bottom: parent.bottom
        anchors.right: rejectButton.left
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        fontSizeMode: Text.Fit
        color: Colours.almostWhite
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea {
        anchors.fill: parent
        enabled: container.status === "active"
        onClicked: {
            chat();
        }
    }
    //
    //
    //
    AfterTrauma.Button {
        id: rejectButton
        anchors.top: parent.top
        anchors.right: acceptButton.visible ? acceptButton.left : parent.right
        anchors.margins: 8
        text: acceptButton.visible ? "Reject" : "Remove"
        backgroundColour: "transparent"
        onClicked: {
            reject();
        }
    }
    AfterTrauma.Button {
        id: acceptButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        text: "Accept"
        backgroundColour: "transparent"
        onClicked: {
            accept();
        }
    }
    //
    //
    //
    signal reject()
    signal accept()
    signal chat()
    //
    //
    //
    property alias avatar: avatarImage.source
    property alias withUsername: withUsernameText.text
    property string to: ""
    property string from: ""
    property string status: ""
    property alias showAccept: acceptButton.visible
}
