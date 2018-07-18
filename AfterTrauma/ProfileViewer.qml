import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    title: "PROFILE"
    colour: Colours.almostWhite
    //
    //
    //
    contentItem: Flickable {
        anchors.fill: parent
        contentHeight: profileItems.childrenRect.height + 16
        //
        //
        //
        Column {
            id: profileItems
            anchors.fill: parent
            spacing: 4
            Image {
                id: avatarImage
                anchors.left: parent.left
                anchors.right: parent.right
                fillMode: Image.PreserveAspectFit
            }
            //
            //
            //
            Text {
                id: profileText
                anchors.left: parent.left
                anchors.right: parent.right
                wrapMode: Text.WordWrap
            }
            //
            //
            //
            Text {
                id: tagsText
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
    //
    //
    //
    WebSocketChannel {
        id: profileChannel
        url: baseWS
        //
        //
        //
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object
            console.log( 'ProfileViewer recieved command ' + command.command + ' : status : ' + command.status );
            if ( command.command === 'welcome' ) {
                command = {
                    command: 'filterpublicprofiles',
                    token: userProfile.token,
                    filter: { id: userId }
                };
                send( command );
            } else if ( command.command === 'filterpublicprofiles' ) {
                if( command.status === "OK" ) {
                    if ( command.response && command.response.length > 0 ) {
                        var profile = command.response[ 0 ];
                        title = profile.username;
                        avatarImage.source = profile.avatar || "icons/profile_icon.png";
                        profileText.text = profile.profile;
                        tagsText.text = profile.tags.join();
                    } else {
                        console.log( 'ProfileViewer invalid response ' + JSON.stringify(command.response) + ' : filter : ' + JSON.stringify(command.filter) );
                    }
                } else {
                    errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { stack.pop(); } },
                                     ] );
                }
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        profileChannel.open();
    }
    StackView.onDeactivated: {
        profileChannel.close();
    }
    //
    //
    //
    property string userId: ""
}
