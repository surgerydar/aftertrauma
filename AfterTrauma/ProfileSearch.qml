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
            text: "FIND PEOPLE"
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
        id: profiles
        width: container.width - 16
        anchors.top: header.bottom
        anchors.bottom: searchTerm.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 8
        clip: true
        spacing: 4
        model: WebSocketList {
            url: baseWS
            roles: ["_id","id","username","profile","avatar"]
        }
        delegate: ProfileSearchItem {
            width: profiles.width
            userId: model.id || ""
            avatar: ( model.avatar || "qrc://icons/profile_icon.png" ) +  '?width=56&height=56'
            username: model.username || ""
            profile: model.profile || ""
            actionLabel: "add"
            selectionEnabled: container.selectionEnabled
            onSelectedChanged: {
                var user = {
                    _id: model._id,
                    id: model.id,
                    avatar: model.avatar,
                    username: model.username,
                    profile:  model.profile
                };
                container.action(user,selected);
            }
            onAction: {
                profileViewer.open(id,container.enableDirectChat);
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
    Label {
        anchors.verticalCenter: profiles.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        visible: attemptedSearch && profiles.count === 0
        font.family: fonts.light
        font.pointSize: 18
        color: Colours.almostWhite
        wrapMode: Label.WordWrap
        horizontalAlignment: Label.AlignHCenter
        text: "no users match your search"
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
                Qt.callLater( updateSearch, text );
                /*
                console.log( 'searching for text : ' + text );
                profiles.model.command = {
                    command: 'filterpublicprofiles',
                    filter: {$and:[{id:{$not:{$eq:userProfile.id}}},{username: { $regex: '^' + text, $options:'i'} }]}
                };
                profiles.model.refresh();
                */
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
    function updateSearch( text ) {
        attemptedSearch = true;
        console.log( 'searching for text : ' + text );
        var exclude = [userProfile.id]; // TODO: exclude users currenly
        var regex = { $regex: '^' + text, $options:'i'};
        profiles.model.command = {
            command: 'filterpublicprofiles',
            filter: {$and:[{id:{$nin:exclude}},{ $or:[{username: regex},{tags: regex}]}]}
        };
        profiles.model.refresh();
        //
        //
        //
        usageModel.add('chat', 'search', 'people', { searchterm: text } );
    }
    //
    //
    //
    function open( enableSelection ) {
        attemptedSearch = false;
        selectionEnabled = enableSelection;
        container.state = "open";
        console.log('ProfileSearch.open');
        profiles.model.open();
    }
    function close() {
        container.state = "closed";
        console.log('ProfileSearch.close');
        profiles.model.close();
        container.closed();
    }
    property bool attemptedSearch: false
    property bool selectionEnabled: true
    property bool enableDirectChat: true
}
