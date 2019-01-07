import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Rectangle {
    id: container
    height: parent.height
    y: parent.height
    anchors.left: parent.left
    anchors.right: parent.right
    color: Colours.blue
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
            text: "PROFILE"
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
        id: contents
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.margins: 4
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: AfterTrauma.Block {
            /*
            anchors.left: parent.left
            anchors.right: parent.right
            */
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            type: model.type
            media: model.content
            onMediaReady: {
                contents.forceLayout();
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: footer
        height: 64
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colours.blue
        //
        //
        //
        AfterTrauma.Button {
            id: abuseButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            text: "report abuse"
            visible: userProfile.id !== userId
            onClicked: {
                abuseDialog.show("Report Abuse", [
                    {label:"Cancel", action: function() {} },
                    {label:"Ok", action: function() {
                            var command = {
                                command: 'blockprofile',
                                token: userProfile.token,
                                id: userId,
                                complaint: abuseDialog.content
                            };
                            profileChannel.send( command );
                        }
                    }
                ]);
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            id: chatButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 16
            image: "icons/chat.png"
            visible: directChatEnabled
            onClicked: {
                var chat = chatModel.findPrivateChatWithUser(userId);
                if ( chat ) {
                    var properties = {
                        chatId:chat.id,
                        messages:chatModel.getMessageModel(chat.id),
                        subject: chat.subject
                    };
                    stack.push( "qrc:///GroupChat.qml", properties);
                } else {
                    //
                    // create new chat
                    //
                    chat = {
                        id: GuidGenerator.generate(),
                        owner: userProfile.id,
                        subject: "Chat with " + title.text,
                        "public": false,
                        members: [userId],
                        active: [userId],
                        messages: []
                    };
                    chatEditor.show(chat, function(edited,showChat) {
                        var command = {
                            command: 'groupcreatechat',
                            token: userProfile.token,
                            chat: edited,
                            show: showChat
                        };
                        chatChannel.send(command);
                    });
                }
                close();
            }
        }
    }
    //
    //
    //
    AfterTrauma.TextEntryDialog {
        id: abuseDialog
        placeholder: "describe abuse"
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
                        title.text = profile.username;
                        contents.model.clear();
                        contents.model.append( {
                                                  type: 'image',
                                                  content: profile.avatar || "qrc:///icons/profile_icon.png"
                                              });
                        if ( profile.age || profile.gender )
                            contents.model.append( {
                                                      type: 'text',
                                                      content: Utils.formatAgeAndGender( profile )
                                                  });
                        if ( profile.profile && profile.profile.length > 0 )
                            contents.model.append( {
                                                      type: 'text',
                                                      content: profile.profile
                                                  });
                        if ( profile.tags && profile.tags.length > 0 )
                            contents.model.append( {
                                                      type: 'text',
                                                      content: profile.tags.join()
                                                  });
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
    function open( _userId, enableDirectChat ) {
        directChatEnabled = enableDirectChat || false;
        userId = _userId;
        container.state = "open";
        contents.model.clear();
        profileChannel.open();
    }
    function close() {
        container.state = "closed";
        profileChannel.close();
    }
    //
    //
    //
    property string userId: ""
    property bool directChatEnabled: false
}
