import QtQuick 2.6
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    //
    //
    //
    background: AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        opacity: .5
    }
    //
    //
    //
    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 32
        padding: 32
        Text {
            id: prompt
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: container.width - 32
            wrapMode: Text.WordWrap
            font.weight: Font.Bold
            font.family: fonts.light
            font.pixelSize: 24
            color: Colours.darkSlate
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            Repeater {
                model: buttons.length
                //
                //
                //
                Item {
                    height: 48
                    width: label.contentWidth + 16
                    AfterTrauma.Background {
                        anchors.fill: parent
                        fill: Colours.darkSlate
                        opacity: .25
                    }
                    Text {
                        id: label
                        anchors.fill: parent
                        font.family: fonts.light
                        font.weight: Font.Bold
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: Colours.almostWhite
                        text: buttons[ index ].label
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            buttons[ index ].action();
                            container.close();
                        }
                    }
                }
            }
        }
    }
    //
    //
    //
    WebSocketChannel {
        id: updateChannel
        url: baseWS
        //
        //
        //
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object???
            if ( command.status === "OK" ) {
                if ( command.command === 'categories' ) {
                    if ( command.response.length > 0 ) {
                        processCategories(command.response);
                    }
                    send({command:'manifest',date:0});
                } else if ( command.command === 'manifest' ) {
                    //console.log( 'manifest : ' + JSON.stringify(command.response) );
                    if ( command.response.length > 0 ) {
                        confirmDialog.show('<h1>Updates Available</h1>Do you want to download and install now?', [
                                           { label: 'yes', action: function() { processUpdate(command.response) } },
                                           { label: 'no', action: function() { container.close(); } }
                                           ] );
                    } else {
                        container.close();
                    }
                } else if ( command.command === 'documents' ) {
                    if ( command.response.length > 0 ) {
                        //console.log( 'documents : ' + JSON.stringify(command.response[0]) );
                        installDocuments(command.response);
                    }
                    send({command:'challenges',date:0});
                } else if ( command.command === 'challenges' ) {
                    if ( command.response.length > 0 ) {
                        installChallenges(command.response);
                    }
                    container.close();
                } else if ( command.command === 'resetpassword' ) {
                    confirmDialog.show('<h1>Password Reset</h1>' + command.response );
                }
            } else if ( command.error ) {
                errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), userProfile ?
                                     [
                                         { label: 'try again', action: function() {} }
                                     ] :
                                     [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { container.close(); } },
                                     ] );
            } else {
                console.log( 'unknown message: ' + message );
            }
        }
        onError: {
            busyIndicator.running = false;
            errorDialog.show( '<h1>Network error</h1><br/>' + error, userProfile ?
                                 [
                                     { label: 'try again', action: function() {} }
                                 ] :
                                 [
                                     { label: 'try again', action: function() {} },
                                     { label: 'forget about it', action: function() { container.close(); } },
                                 ] );
        }
        onOpened: {
            send({command:'categories',date:0});
        }
        onClosed: {

        }
    }
    Component.onCompleted: {

    }
    onOpened: {
        updateChannel.open();
    }
    onClosed: {
        updateChannel.close();
    }
    //
    //
    //
    property var buttons: [{label:'ok',action:function() { container.close() }}]
}
