import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    height: 64
    color: Colours.almostWhite
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
        //
        //
        //
        onStatusChanged: {
            if ( status === Image.Error ) {
                console.log( 'error loading avatar icon : ' + source );
                source = "icons/profile_icon.png";
            }
        }
    }
    //
    //
    //
    Text {
        id: subjectText
        height: 32
        anchors.top: parent.top
        anchors.left: avatarImage.right
        anchors.right: parent.left
        anchors.bottom: parent.verticalCenter
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        color: Colours.darkSlate
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            container.clicked();
        }
    }
    //
    //
    //
    signal clicked();
    //
    //
    //
    property alias avatar: avatarImage.source
    property alias subject: subjectText.text
}
