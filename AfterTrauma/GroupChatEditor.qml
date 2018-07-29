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
            enabled: subjectField.text.length > 0 && ( membersList.count > 0 || publicCheckBox.checked )
            onClicked: {
                save(false);
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
            onOpened: {
                Qt.callLater( setMembers, members || [] );

            }
            onError: {
                console.log( 'membersList.model : error : ' + error );
            }
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
                Qt.callLater( setMembers, temp );
                //members = temp;
            }
        }
    }
    //
    //
    //
    AfterTrauma.Label {
        width: membersList.width
        anchors.centerIn: membersList
        visible: membersList.count === 0
        text: "please add people"
        onVisibleChanged: {
            console.log( 'add people label visible=' + visible );
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
        AfterTrauma.Button {
            id: chatButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            image: "icons/chat.png"
            onClicked: {
                save( true );
                container.close();
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            id: addEntry
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            backgroundColour: "transparent"
            text: "add people"
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
            Qt.callLater( setMembers, temp );
            //members = temp;
        }
        onClosed: {
        }
    }
    //
    //
    //
    function show( _chat, callbackFunction ) {
        chat = _chat;
        subjectField.text = _chat.subject;
        tagsField.text = _chat.tags ? _chat.tags.join() : "";
        publicCheckBox.checked = _chat['public'];
        members = _chat.members || [];
        //
        //
        //
        callback = callbackFunction;
        //
        //
        //
        open();
    }

    function setMembers( _members ) {
        console.log( 'setting members : ' + JSON.stringify(_members) );
        members = _members;
        membersList.model.command = {
            command: 'filterpublicprofiles',
            filter: {id:{$in:members}}
        };
        membersList.model.refresh();
    }

    function save( viewChat ) {
        if ( callback ) {

            chat.subject = subjectField.text;
            var tags = tagsField.text.split();
            chat.tags = [];
            tags.forEach( function(tag) {
                var trimmedTag = tag.trim().toLowerCase();
                if ( chat.tags.indexOf(trimmedTag) < 0 ) {
                    chat.tags.push(trimmedTag);
                }
            });
            //
            // TODO: store usernames
            //
            chat.members = members;
            chat.usernames = [];
            for ( var i = 0; i < membersList.model.count; i++ ) {
                chat.usernames.push( membersList.model.get(i).username );
            }
            chat["public"] = publicCheckBox.checked;
            console.log( 'new chat : ' + JSON.stringify(chat) );
            callback(chat,viewChat);
        }
    }

    property var callback: undefined
    property var chat: undefined
    property var members: []
}
