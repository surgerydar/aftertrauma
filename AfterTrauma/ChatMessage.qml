import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max( 64, messageText.contentHeight + 16 )
    //
    //
    //
    Image {
        id: avatarImage
        width: 48
        height: width
        anchors.top: parent.top
        anchors.left: from === userProfile.id ? parent.left : undefined
        anchors.right: from === userProfile.id ? undefined : parent.right
        fillMode: Image.PreserveAspectFit
        source: baseURL + "/avatar/" + from
        onStatusChanged: {
            if ( status === Image.Error ) {
                source = "icons/profile_icon.png";
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                profileViewer.open( from );
            }
        }
    }
    //
    //
    //
    Item {
        anchors.fill: parent
        anchors.leftMargin: from === userProfile.id ? 56 : 0
        anchors.rightMargin: from === userProfile.id ? 0 : 56
        //
        //
        //
        AfterTrauma.Background {
            anchors.fill: parent
            radius: [8]
            fill: Colours.almostWhite
        }
        //
        //
        //
        Text {
            id: messageText
            anchors.fill: parent
            anchors.margins: 8
            color: Colours.veryDarkSlate
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.family: fonts.light
            font.pixelSize: 24
        }
    }
    //
    //
    //
    property alias message: messageText.text
    property string from: ""
}
