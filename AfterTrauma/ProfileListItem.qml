import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.EditableListItem {
    id: container
    contentItem: Item {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
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
                    console.log( 'error loading avatar icon : ' + source );
                    source = "icons/profile_icon.png";
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
            anchors.bottom: parent.verticalCenter
            anchors.margins: 4
            //
            //
            //
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 18
            color: Colours.almostWhite
        }
        //
        //
        //
        Text {
            id: profileText
            anchors.top: parent.verticalCenter
            anchors.left: avatarImage.right
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 4
            //
            //
            //
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 12
            color: Colours.almostWhite
        }
        /*
        //
        //
        //
        AfterTrauma.Button {
            id: chatButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 8
            backgroundColour: "transparent"
            text: "Invite"
            onClicked: {
                //
                // send chat invite
                //
                sendChatInvite( userId );
            }
        }
        */
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
