import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

Item {
    id: container
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
                    command: 'golive',
                    id: userProfile.id,
                    username: userProfile.username
                }
                send( command );
            }
            connected = true;
        }
        onClosed: {
            console.log( 'ChatChannel : closed' );
            connected = false;
            pollConnection.start();
        }

        onReceived: {
            var command = JSON.parse(message);
            console.log( 'ChatChannel : received : ' + message );
            if ( command.status === 'OK' ) {
                switch( command.command ) {
                case 'getuserchats':
                    container.getuserchats( command );
                    break;
                case 'sendmessage':
                    container.sendmessage( command );
                    break;
                case 'sendinvite':
                    container.sendinvite( command );
                    break;
                case 'acceptinvite':
                    container.acceptinvite( command );
                    break;
                case 'removechat':
                    container.removechat( command );
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
            chatChannel.open();
        }
    }
    //
    //
    //
    function open() {
        chatChannel.open();
    }
    function close() {
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
    signal getuserchats( var command )
    signal sendmessage( var command )
    signal sendinvite( var command )
    signal acceptinvite( var command )
    signal removechat( var command )
    //
    //
    //
    property bool connected: false
}
