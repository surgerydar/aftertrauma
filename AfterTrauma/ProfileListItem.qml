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
        //
        //
        //
        onStatusChanged: {
            if ( status === Image.Error ) {
                source = "icons/profile_icon.png"
            }
        }
    }
    //
    //
    //
    Text {
        id: usernameText
        height: 32
        anchors.top: parent.top
        anchors.left: avatarImage.right
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        color: Colours.almostWhite
    }
    //
    //
    //
    Text {
        id: profileText
        anchors.top: usernameText.bottom
        anchors.left: avatarImage.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 12
        color: Colours.almostWhite
    }
    //
    //
    //
    AfterTrauma.Button {
        id: chatButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        backgroundColour: "transparent"
        image: "icons/chat.png"
        onClicked: {
            //
            // send chat invite
            //
            sendChatInvite( userId );
        }
    }
    //
    //
    //
    signal sendChatInvite( string toId );
    //
    //
    //
    property alias avatar: avatarImage.source
    property alias username: usernameText.text
    property alias profile: profileText.text
    property string userId: ""
}
