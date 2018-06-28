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
        spacing: 4
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
            anchors.margins: 8
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
                var exclude = [userProfile.id];
                var count = chatModel.count;
                for ( var i = 0; i < count; i++ ) {
                    var chat = chatModel.get(i);
                    if ( exclude.indexOf(chat.from) < 0 ) exclude.push( chat.from );
                    if ( exclude.indexOf(chat.to) < 0 ) exclude.push( chat.to );
                }
                console.log( JSON.stringify(exclude));
                stack.push("qrc:///ProfileList.qml",{exclude:exclude});
                /*
                var chat = {
                    owner: userProfile.id,
                    subject: "",
                    isPublic: false
                }
                chatEditor.show(chat, function(edited) {

                });
                */
            }
        }
    }

    StackView.onActivated: {
        //chatChannel.open();
        chatModel.load();
    }
    StackView.onDeactivated: {
        //chatChannel.close();
    }
    //
    //
    //
    /*
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
    */
    Connections {
        target: chatChannel
        onGetuserchats:{
            chatModel.clear();
            chatModel.beginBatch();
            command.response.forEach(function(chat) {
                chatModel.batchAdd(chat);
            });
            chatModel.endBatch();
            chatModel.save();
        }
        onSendinvite:{
            console.log( 'ChatManager : invite received')
            if ( command.to === userProfile.id ) {
                var chat = command;
                chat.status = 'invite';
                chat.response = undefined;
                chat.messages = [];
                chatModel.add( chat );
                chatModel.save();
            }
        }
        onAcceptinvite:{
            //
            // FIXME: possible error here ????
            //
            console.log( 'ChatManager : invite accepted')
            chatModel.update({id: command.id},{status:"active"});
            chatModel.save();
        }
        onSendmessage:{
            console.log( 'ChatManager : message recieved');
            if ( command.to === userProfile.id ) {
                var chat = chatModel.findOne({id:command.id});
                if ( chat ) {
                    var newMessage = { from: command.from, message: command.message };
                    chat.messages.push( newMessage );
                    chatModel.update({id:command.id},{messages:chat.messages});
                    chatModel.save();
                }
            }
        }
        onRemovechat:{
            console.log( 'ChatManager : chat removed');
            chatModel.remove({id: command.id});
            chatModel.save();
        }
    }
}
