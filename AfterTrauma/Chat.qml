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
        height: Math.max( addMessage.height, messageText.contentHeight ) + 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.TextArea {
            id: messageText
            height: contentHeight + 16
            anchors.top: parent.top
            anchors.left: parent.left
            //anchors.bottom: parent.bottom
            anchors.right: addMessage.left
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            anchors.bottomMargin: 28
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
                    var message = { from: userProfile.id, message: messageText.text };
                    messageList.model.append( message );
                    messageText.text = "";
                    messageList.positionViewAtEnd();
                    //
                    //
                    //
                    var command = {
                        command: 'sendmessage',
                        id: chatId,
                        from: message.from,
                        to: recipient,
                        message: message.message
                    };
                    chatChannel.send(command);
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
        chatChannel.open();
        if( messages ) {
            try {
                messages.forEach(function(message){
                    messageList.model.append(message);
                });
            } catch( err ) {
                var count = messages.count;
                for ( var i = 0; i < count; i++ ) {
                    messageList.model.append( messages.get(i) );
                }
            }
        }
    }
    StackView.onDeactivated: {
        chatChannel.close();
    }
    //
    //
    //
    WebSocketChannel {
        id: chatChannel
        url: "wss://aftertrauma.uk:4000"
        //
        //
        //
        onOpened: {
            //
            // go live
            //
            var command = {
                command: 'golive',
                id: userProfile.id,
                username: userProfile.username
            }
            send( command );
        }
        onReceived: {
            var command = JSON.parse(message);
            if ( command === 'sendmessage' ) {
                if ( command.id === chatId && command.status === 'OK' && command.from !== userProfile.id ) {
                    //
                    // TODO: sort by date
                    //
                    messageList.model.append( { from: command.from, message: command.message } );
                    messageList.positionViewAtEnd();
                }
            }
        }
    }
    //
    //
    //
    property var messages: null
    property alias recipientUsername: container.subtitle
    property string recipient: ""
    property string chatId: ""
}
