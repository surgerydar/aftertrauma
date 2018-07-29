import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    color: Colours.darkPurple
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
            text: "FIND GROUPS"
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
            image: "icons/close.png"
            onClicked: {
                container.close();
            }
        }
    }
    //
    //
    //
    ListView {
        id: chats
        width: container.width - 16
        anchors.top: header.bottom
        anchors.bottom: searchTerm.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 8
        clip: true
        spacing: 4
        model: WebSocketList {
            url: "wss://aftertrauma.uk:4000"
            roles: ["_id","id","owner","subject","tags","members"]
        }
        delegate: GroupChatSearchItem {
            width: chats.width
            avatar: "https://aftertrauma.uk:4000/avatar/" + model.owner
            subject: model.subject
            onClicked: {
                action( model.id );
            }
        }
        //
        //
        //
        add: Transition {
            NumberAnimation {
                properties: "y,opacity"
                from: chats.height
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
        placeholderText: "subject"
        onTextChanged: {
            if ( text.length > 0 ) {
                Qt.callLater( updateSearch, text );
            } else {
                chats.model.clear();
            }
        }
    }
    //
    //
    //
    signal action( string chatId )
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
                opacity: 0.
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                y: 0
                opacity: 1.
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
    //
    //
    //
    function updateSearch( text ) {
        console.log( 'searching for text : ' + text );
        var exclude = [userProfile.id]; // TODO: exclude users currenly
        //var regex = { $regex: '^' + text, $options:'i'};
        var regex = { $regex: text, $options:'i'};
        chats.model.command = {
            command: 'groupfilterchats',
            filter: { $and: [{ "public": true },{ $or:[{subject: regex},{tags: regex}]}]}
        };
        chats.model.refresh();
    }
    //
    //
    //
    function open() {
        container.state = "open";
        console.log('GroupChatSearch.open');
        chats.model.open();
    }
    function close() {
        container.state = "closed";
        console.log('GroupChatSearch.close');
        chats.model.close();
        //container.closed();
    }
}
