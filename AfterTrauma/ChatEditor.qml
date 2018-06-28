import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    height: parent.height
    y: parent.height
    anchors.left: parent.left
    anchors.right: parent.right
    color: Colours.darkPurple
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                y: container.height
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
        //profileChannel.open();
        membersList.model.open();
    }
    function close() {
        container.state = "closed";
        //profileChannel.close();
        membersList.model.close();
    }
    //
    // titlebar
    //
    Item {
        id: titlebar
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "cancel"
            onClicked: {
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "save"
            enabled: subjectField.text.length > 0 && membersList.count > 0
            onClicked: {
                if ( callback ) {
                    chat.subject = subjectField.text;
                    var tags = tagsField.text.split();
                    chat.tags = [];
                    tags.forEach( function(tag) {
                        chat.tags.push( tag.trim().toLowerCase() );
                    });
                    //
                    // TODO: send invites
                    //
                    chat.members = members;
                    console.log( 'new chat : ' + JSON.stringify(chat) );
                    callback(chat);
                }
                container.close();
            }
        }
    }
    //
    //
    //
    AfterTrauma.TextField {
        id: subjectField
        width: container.width - 8
        anchors.top: titlebar.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: "subject"
    }
    AfterTrauma.TextField {
        id: tagsField
        width: container.width - 8
        anchors.top: subjectField.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: "tag,tag,tag"
    }
    AfterTrauma.CheckBox {
        id: publicCheckBox
        width: container.width - 8
        anchors.top: tagsField.bottom
        anchors.topMargin: 8
        anchors.left: tagsField.left
        textColour: Colours.almostWhite
        text: "public"
    }
    //
    //
    //
    Rectangle {
        anchors.fill: membersList
        anchors.margins: -4
        color: Colours.almostWhite
    }
    ListView {
        id: membersList
        width: container.width - 16
        anchors.top: publicCheckBox.bottom
        anchors.topMargin: 8
        anchors.bottom: footer.top
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        spacing: 4
        model: WebSocketList {
            url: "wss://aftertrauma.uk:4000"
            roles: ["_id","id","username","profile","avatar"]
        }
        delegate: ProfileListItem {
            width: membersList.width
            avatar: model.avatar
            username: model.username
            profile: model.profile
            userId: model.id
            contentEditable: false
            onRemove: {
                var temp = members;
                temp.splice( index, 1 );
                members = temp;
            }
        }
    }
    //
    //
    //
    Item {
        id: footer
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        //
        //
        //
        /*
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: membersList.editable ? "done" : "edit"
            onClicked: {
                membersList.editable = !membersList.editable;
            }
        }
        */
        //
        //
        //
        AfterTrauma.Button {
            id: addEntry
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            backgroundColour: "transparent"
            text: "add user"
            onClicked: {
                profileSearch.open();
            }
        }
    }
    //
    //
    //
    ProfileSearch {
        id: profileSearch
        width: container.width
        height: container.height
        x: 0
        onAction: {
            console.log( "ProfileSearch : " + (selected?"selected":"deselected") + " : " + user.id );
            var temp = members;
            if ( selected ) {
                var count = temp.length;
                for ( var i = 0; i < count; i++ ) {
                    if ( temp[i] === user.id ) {
                        return;
                    }
                }
                temp.push(user.id);
            } else {
                var offset = temp.indexOf(user.id);
                if ( offset >= 0 ) {
                    temp.splice( offset, 1 );
                }
            }
            console.log( '' )
            members = temp;
        }
        onClosed: {
        }
    }
    /*
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
                    membersList.model.clear();
                    command.response.forEach(function( profile ) {
                        membersList.model.append( profile );
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
    */
    //
    //
    //
    /*
    onMembersChanged: {
        var command = {
            command: 'filterpublicprofiles',
            filter: {id:{$in:members}}
        };
        busyIndicator.running = true;
        profileChannel.send(command);
    }
    */
    onMembersChanged: {
        console.log( 'ChatEditor.onMembersChanged')
        membersList.model.command = {
            command: 'filterpublicprofiles',
            filter: {id:{$in:members}}
        };
        membersList.model.refresh();
    }
    //
    //
    //
    function show( c, callbackFunction ) {
        chat = c;
        subjectField.text = c.subject;
        tagsField.text = c.tags ? c.tags.join() : "";
        publicCheckBox.checked = c.isPublic;
        //
        // populate membersList
        //
        members = chat.members || [];
        //
        //
        //
        callback = callbackFunction;
        //
        //
        //
        open();
    }

    property var callback: undefined
    property var chat: undefined
    property var members: []
}
