import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "USERS"
    colour: Colours.darkPurple
    //
    //
    //
    ListView {
        id: profiles
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
        model: ListModel {}
        //
        //
        //
        delegate: ProfileListItem {
            anchors.left: parent.left
            anchors.right: parent.right
            avatar: model.avatar || "icons/profile_icon.png"
            username: model.username
            profile: model.profile
            userId: model.id
            onSendChatInvite: {
                var command = {
                    command: "sendinvite",
                    id: GuidGenerator.generate(),
                    from: userProfile.id,
                    fromUsername: userProfile.username,
                    to: model.id,
                    toUsername: model.username
                }
                profileChannel.send(command);
            }
        }
    }
    StackView.onActivated: {
        //
        //
        //
        console.log('opening profileChannel');
        profileChannel.open();

    }
    StackView.onDeactivated: {
        //
        //
        //
        console.log('closing profileChannel');
        profileChannel.close();
    }
    //
    //
    //
    WebSocketChannel {
        id: profileChannel
        url: "wss://aftertrauma.uk:4000"
        onReceived: {
            busyIndicator.running = false;
            var command = JSON.parse(message); // TODO: channel should probably emit object
            if ( command.command === 'getpublicprofiles' ) {
                if( command.status === "OK" ) {
                    profiles.model.clear();
                    command.response.forEach(function( profile ) {
                        profiles.model.append( profile );
                    });
                } else {
                    errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                         { label: 'try again', action: function() {} },
                                         { label: 'forget about it', action: function() { stack.pop(); } },
                                     ] );
                }
            }
        }
        onOpened: {
            console.log('profileChannel open');
            busyIndicator.running = true;
            send({command: 'getpublicprofiles', exclude: userProfile.id });
        }
        onClosed: {
            console.log('profileChannel closed');
        }
    }
}
