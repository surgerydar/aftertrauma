import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "CHATS"
    colour: Colours.darkPurple
    //
    //
    //
    ListView {
        id: chats
        anchors.fill: parent
        anchors.bottomMargin: 8
        //
        //
        //
        clip: true
        spacing: 8
        //
        //
        //
        model: chatModel
        //
        //
        //
        section.property: "status"
        section.delegate: Text {
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            font.weight: Font.Light
            font.family: fonts.light
            font.pixelSize: 32
            font.capitalization: Font.Capitalize
            color: Colours.almostWhite
            text: section
        }
        //
        //
        //
        delegate: ChatItem {
            //anchors.left: chats.left
            //anchors.right: chats.right
            width: parent.width
            to: model.to
            from: model.from
            withUsername: model.to === userProfile.id ? model.fromUsername : model.toUsername
            avatar: "https://aftertrauma.uk:4000/avatar/" + ( model.to === userProfile.id ? model.from : model.to )
            status: model.status || "unknown"
            showAccept: model.status === "invite" && model.to === userProfile.id
            onAccept: {
                var command = {
                    command: 'acceptinvite',
                    id: model.id,
                    from: model.from,
                    to: model.to,
                    fromUsername: model.fromUsername,
                    toUsername: model.toUsername
                };
                console.log( 'accepting invite : ' + JSON.stringify(command) );
                chatChannel.send(command);
            }
            onReject: {
                var command = {
                    command: 'removechat',
                    id: model.id,
                    from: model.from,
                    to: model.to,
                    fromUsername: model.fromUsername,
                    toUsername: model.toUsername
                };
                console.log( 'remove chat : ' + JSON.stringify(command) );
                chatChannel.send(command);
            }
            onChat: {
                var properties = {
                    chatId:model.id,
                    messages:chatModel.getMessageModel(model.id),
                    recipient: model.to === userProfile.id ? model.from : model.to,
                    recipientUsername:model.to === userProfile.id ? model.fromUsername : model.toUsername
                };
                stack.push( "qrc:///Chat.qml", properties);
            }
        }
    }
    //
    //
    //
    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            id: addChat
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                stack.push("qrc:///ProfileList.qml");
            }
        }
    }

    StackView.onActivated: {
        chatChannel.open();
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
            //
            // request chats
            //
            command = {
                command: 'getuserchats',
                id: userProfile.id
            }
            send( command );
        }
        onClosed: {

        }
        onReceived: {
            //
            //
            //
            var command = JSON.parse(message);
            if ( command.command === 'getuserchats' ) {
                if( command.status === "OK" ) {
                    chatModel.clear();
                    chatModel.beginBatch();
                    command.response.forEach(function(chat) {
                        chatModel.batchAdd(chat);
                    });
                    chatModel.endBatch();
                    chatModel.save();
                } else {
                    console.log( 'error : ' + message );
                    errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { stack.pop(); } },
                                     ] );
                }
            } else if ( command.command === 'sendinvite' ) {
                if ( command.to === userProfile.id ) {
                    chatModel.add( command );
                    chatModel.save();
                }
            } else if ( command.command === 'acceptinvite' ) {
                //
                // FIXME: possible error here ????
                //
                chatModel.update({id: command.id},{status:"active"});
                chatModel.save();
            } else if ( command.command === 'removechat' ) {
                //
                //
                //
                chatModel.remove({id: command.id});
                chatModel.save();
            } else if ( command.command === 'sendmessage' ) {
                if ( command.to === userProfile.id ) {
                    var chat = chatModel.findOne({id:command.id});
                    if ( chat ) {
                        var newMessage = { from: command.from, message: command.message };
                        chat.messages.push( newMessage );
                        chatModel.update({id:command.id},{messages:chat.messages});
                    }
                }
            }
        }
    }
}
