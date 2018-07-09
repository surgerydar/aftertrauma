import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

Item {
    id: container
    //
    //
    //
    y: parent.height
    // TODO: network status indicator
    /* DEBUG UI
    anchors.fill: parent
    Rectangle {
        anchors.fill: response
        color: "white"
    }
    TextArea {
        id: response
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 8
    }
    Rectangle {
        anchors.fill: source
        color: "white"
    }

    TextArea {
        id: source
        anchors.top: parent.verticalCenter
        anchors.left: parent.left
        anchors.bottom: action.top
        anchors.right: parent.right
        anchors.margins: 8
    }
    Button {
        id: action
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        text: "send"
        onClicked: {
            var src = source.text;
            try {
            var command = JSON.parse(src);
            if ( command ) {
                send( command );
            }
            } catch( error ) {
                console.log(error.name);
                console.log(error.lineNumber);
                console.log(error.columnNumber);
            }
        }
    }
    */
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
            console.log( 'ChatChannel : open' );
            if ( userProfile ) {
                //
                // go live
                //
                console.log( 'Chat : chatChannel open going live' );
                var command = {
                    command: 'groupgolive',
                    id: userProfile.id,
                    username: userProfile.username
                }
                send( command );
            }
            connected = true;
        }
        //
        //
        //
        onClosed: {
            console.log( 'ChatChannel : closed' );
            connected = false;
            pollConnection.start();
        }
        //
        //
        //
        onReceived: {
            //response.text = message;
            var command = JSON.parse(message);
            console.log( 'ChatChannel : received : ' + message );
            if ( command.command === 'welcome' ) {
                send({
                         command: 'groupgetuserchats',
                         token: userProfile.token,
                         id: userProfile.id
                     });
            } else if ( command.status === 'OK' ) {
                switch( command.command ) {
                case 'groupgetuserchats':
                    // TODO: container.getUserChats( command );
                    chatModel.clear();
                    chatModel.beginBatch();
                    command.response.forEach(function(chat) {
                        //
                        // TODO: update rather than replace, store ids for future delete
                        //
                        console.log( 'adding user chat: ' + JSON.stringify( chat ) );
                        chatModel.batchAdd(chat);
                    });
                    chatModel.endBatch();
                    //
                    //
                    //
                    chatModel.save();
                    break;
                case 'groupcreatechat':
                    //
                    // update database
                    //
                    chatModel.add(command.chat);
                    chatModel.save();
                    //
                    //
                    //
                    container.createChat( command );
                    break;
                case 'groupupdatechat':
                    //
                    // update database
                    //
                    chatModel.update({id:command.chat.id},command.chat);
                    chatModel.save();
                    //
                    // pass it on
                    //
                    container.updateChat( command );
                    break;
                case 'groupremovechat':
                    //
                    // remove from database
                    //
                    chatModel.remove({id:command.chatid});
                    chatModel.save();
                    //
                    // pass it on
                    //
                    container.removeChat( command );
                    break;
                case 'groupsendmessage': {
                        //
                        // update chat model
                        //
                        var chat = chatModel.findOne({id:command.chatid});
                        if ( chat ) {
                            //
                            // check for duplicate
                            //
                            var message = command.message;
                            var duplicate = false;
                            for ( var i = 0; i < chat.messages.length; i++ ) {
                                if ( chat.messages[ i ].id === message.id ) {
                                    duplicate = true;
                                    break;
                                }
                            }
                            if ( !duplicate ) {
                                //
                                // update cached message model
                                //
                                var messageModel = chatModel.getMessageModel(command.chatid);
                                if ( messageModel ) {
                                    messageModel.add( message );
                                }
                                //
                                // update database
                                //
                                chat.messages.push( message );
                                chatModel.update({id: command.chatid},{ messages: chat.messages, date: message.date || Date.now() });
                                chatModel.save();
                            }
                        }
                        //
                        // pass it on
                        //
                        container.sendMessage( command );
                    }
                    break;
                 }
            } else {
                // TODO: handle error
                console.log( 'ChatChannel : error : ' + command.error );
            }

        }
    }
    //
    //
    //
    Timer {
        id: pollConnection
        interval: 1000
        repeat: false
        onTriggered: {
            console.log('ChatChannel : polling connection');
            if ( !connected ) {
                chatChannel.open();
            }
        }
    }
    //
    //
    //
    function open() {
        chatChannel.open();
    }
    function close() {
        console.log( 'ChatChannel.close' );
        chatChannel.close();
    }
    function send( command ) {
        if ( connected ) {
            return chatChannel.send(command);
        }
        return undefined;
    }
    //
    //
    //
    signal getUserChats( var command )
    signal sendMessage( var command )
    signal createChat( var command )
    signal updateChat( var command )
    signal removeChat( var command )
    //
    //
    //
    property bool connected: false
}
