import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0
Item {
    ListModel {
        id: model
    }
    //
    //
    //
    WebSocketChannel {
        id: profileChannel
        url: baseWS
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object
            if ( command.command === 'filterpublicprofiles' ) {
                if( command.status === "OK" ) {
                    model.clear();
                    command.response.forEach(function( profile ) {
                        model.append( profile );
                    });
                } else {
                    errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() {} },
                                     ] );
                }
            }
        }
        onOpened: {
            console.log('profileChannel open');
            isOpen = true;
        }
        onClosed: {
            console.log('profileChannel closed');
            isOpen = false;
        }
    }
    //
    //
    //
    function open() {
        profileChannel.open();
    }
    function close() {
        profileChannel.close();
    }
    //
    //
    //
    onFilterChanged: {
        if ( isOpen ) {
            var command = {
                command: 'filterpublicprofiles',
                filter: filter
            };
            busyIndicator.running = true;
            profileChannel.send(command);
        }
    }
    //
    //
    //
    property var filter: ({})
    property alias model: model
    property bool isOpen: false
}
