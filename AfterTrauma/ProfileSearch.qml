import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    color: Colours.lightSlate
    //
    //
    //
    signal closed();
    //
    //
    //
    Item {
        id: header
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        Label {
            id: title
            anchors.fill: parent
            anchors.leftMargin: closeButton.width + 24
            anchors.rightMargin: closeButton.width + 24
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            fontSizeMode: Label.Fit
            color: Colours.almostWhite
            font.pixelSize: 36
            font.weight: Font.Light
            font.family: fonts.light
            text: "FIND USERS"
        }
        //
        //
        //
        AfterTrauma.Button {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            image: "icons/down_arrow.png"
            onClicked: {
                container.close();
            }
        }
    }
    //
    //
    //
    ListView {
        id: profiles
        width: container.width - 16
        anchors.top: header.bottom
        anchors.bottom: searchTerm.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 8
        clip: true
        spacing: 4
        model: ListModel {}
        delegate: ProfileSearchItem {
            width: profiles.width
            avatar: model.avatar || "icons/profile_icon.png"
            username: model.username
            profile: model.profile
            actionLabel: "add"
            onSelectedChanged: {
                var user = {
                    _id: model._id,
                    id: model.id,
                    avatar: model.avatar,
                    username: model.username,
                    profile:  model.profile
                };
                action(user,selected);
            }
        }
        //
        //
        //
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: profiles.height
                duration: 250
            }
        }
    }
    //
    //
    //
    AfterTrauma.TextField {
        id: searchTerm
        width: container.width - 16
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 8
        placeholderText: "username"
        onTextChanged: {
            if ( text.length > 0 ) {
                var command = {
                    command: 'filterpublicprofiles',
                    filter: {$and:[{id:{$not:{$eq:userProfile.id}}},{username: { $regex: '^' + text, $options:'i'} }]}
                };
                busyIndicator.running = true;
                profileChannel.send(command);
            } else {
                profiles.model.clear();
            }
        }
    }
    //
    //
    //
    signal action( var user, bool selected)
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                y: parent.height
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                y: 0
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
    //
    //
    //
    function open() {
        container.state = "open";
        console.log('ProfileSearch.open');
        profileChannel.open();
    }
    function close() {
        container.state = "closed";
        console.log('ProfileSearch.close');
        profileChannel.close();
        container.closed();
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
            if ( command.command === 'filterpublicprofiles' ) {
                if( command.status === "OK" ) {
                    profiles.model.clear();
                    command.response.forEach(function( profile ) {
                        profiles.model.append( profile );
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
            //busyIndicator.running = true;
            //send({command: 'getpublicprofiles', exclude: userProfile.id });
        }
        onClosed: {
            console.log('profileChannel closed');
        }
    }
}
