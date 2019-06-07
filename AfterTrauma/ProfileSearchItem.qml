import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    height: 64
    color: Colours.veryLightSlate
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
        anchors.right: selectionEnabled ? select.left : parent.right
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
    //
    //
    //
    Text {
        id: profileText
        anchors.top: parent.verticalCenter
        anchors.left: avatarImage.right
        anchors.bottom: parent.bottom
        anchors.right: selectionEnabled ? select.left : chatButton.left
        anchors.topMargin: 4
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        //
        //
        //
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 12
        color: Colours.darkSlate
    }
    //
    //
    //
    MouseArea {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: select.left//selectionEnabled ? select.left : parent.right
        anchors.margins: 4
        onClicked: {
            action(userId);
            //profileViewer.open(userId);
        }
    }
    //
    //
    //
    AfterTrauma.CheckBox {
        id: select
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        indicatorColour: Colours.lightSlate
        text: "select"
    }
    //
    //
    //
    AfterTrauma.Button {
        id: chatButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        image: "icons/chat.png"
        visible: !selectionEnabled
        onClicked: {
            var chat = chatModel.findPrivateChatWithUser(userId);
            if ( chat ) {
                var properties = {
                    chatId:chat.id,
                    messages:chatModel.getMessageModel(chat.id),
                    subject: chat.subject
                };
                stack.push( "qrc:///GroupChat.qml", properties);
            } else {
                //
                // create new chat
                //
                chat = {
                    id: GuidGenerator.generate(),
                    owner: userProfile.id,
                    subject: "Chat with " + usernameText.text,
                    "public": false,
                    members: [userId],
                    messages: []
                };
                chatEditor.show(chat, function(edited,showChat) {
                    var command = {
                        command: 'groupcreatechat',
                        token: userProfile.token,
                        chat: edited,
                        show: showChat
                    };
                    chatChannel.send(command);
                });
            }
            close();
        }
    }
    //
    //
    //
    signal action(string id);
    //
    //
    //
    property string userId: ""
    property alias avatar: avatarImage.source
    property alias username: usernameText.text
    property alias profile: profileText.text
    property alias selected: select.checked
    property alias actionLabel: select.text
    property alias selectionEnabled: select.visible
}
