import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    title: "CHAT"
    colour: Colours.darkPurple
    //
    //
    //
    ListView {
        id: messageList
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        //
        //
        //
        clip: true
        spacing: 8
        //
        //
        //
        model: ListModel {
        }
        //
        //
        //
        delegate: ChatMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            from: model.from
            message: model.message
        }
        //
        //
        //
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: messageList.height
                duration: 250
            }
        }
    }
    //
    //
    //
    footer: Item {
        height: Math.max( addMessage.height, messageText.contentHeight ) + 16
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.TextArea {
            id: messageText
            height: contentHeight + 16
            //anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: addMessage.left
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            anchors.bottomMargin: 16
            wrapMode: TextArea.WordWrap
        }
        AfterTrauma.Button {
            id: addMessage
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                if ( messageText.text.length > 0 ) {
                    var message = { id: GuidGenerator.generate(), from: userProfile.id, message: messageText.text };
                    //messageList.model.append( message );
                    messageText.text = "";
                    messageList.positionViewAtEnd();
                    //
                    //
                    //
                    var command = {
                        command: 'groupsendmessage',
                        token: userProfile.token,
                        id: GuidGenerator.generate(),
                        chatid: chatId,
                        userid: message.from,
                        message: message
                    };
                    chatChannel.send(command);
                    pendingMessages.push( command );
                }
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 50
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        messageList.positionViewAtEnd();
    }
    StackView.onDeactivated: {
        chatModel.releaseMessageModel(chatId);
    }
    //
    //
    //
    Connections {
        target: chatChannel
        //
        //
        //
        onConnectedChanged: {
            //
            // send pending messages
            //
            // TODO: this may fail half way through so need to requeue those which are not sent
            //
            if ( chatChannel.connected ) {
                /* TODO: disabled during transition to group chat, will have to impliment
                pendingMessages.forEach(function(message){
                    chatChannel.send(message);
                });
                */
                pendingMessages = [];
            }
        }

        onSendMessage: {
            if ( command.chatid === chatId ) {
                messageList.positionViewAtEnd();
            }

        }

    }
    //
    //
    //
    property alias messages: messageList.model
    property alias subject: container.subtitle
    property var pendingMessages: []
    property string chatId: ""
}
