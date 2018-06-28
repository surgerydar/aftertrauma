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
        model: WebSocketList {
            url: "wss://aftertrauma.uk:4000"
            roles: ["_id","id","username","profile","avatar"]
            onOpened: {
                refresh();
            }
        }
        //
        //
        //
        delegate: ProfileListItem {
            anchors.left: parent.left
            anchors.right: parent.right
            avatar: model.avatar || "icons/profile_icon.png"
            username: model.username
            profile: model.profile || ''
            userId: model.id
            swipeEnabled: false
            onSendChatInvite: {
                var command = {
                    command: "sendinvite",
                    id: GuidGenerator.generate(),
                    from: userProfile.id,
                    fromUsername: userProfile.username,
                    to: model.id,
                    toUsername: model.username
                }
                console.log( 'sending chat invite' );
                chatChannel.send(command);
            }
        }
    }

    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.TextField {
            id: searchField
            anchors.left: parent.left
            anchors.right: searchButton.left
            anchors.bottom: parent.bottom
            anchors.margins: 8
            placeholderText: "username or tag"
        }
        //
        //
        //
        AfterTrauma.Button {
            id: searchButton
            anchors.verticalCenter: searchField.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            image: "icons/search.png"
            backgroundColour: "transparent"
            //
            //
            //
            onClicked: {
                search();
            }
        }

    }

    StackView.onActivated: {
        //
        //
        //
        console.log('opening profileChannel');
        profiles.model.clear();
        profiles.model.open();
    }
    StackView.onDeactivated: {
        //
        //
        //
        console.log('closing profileChannel');
        //profileChannel.close();
        profiles.model.close();
    }
    //
    //
    //
    function search() {
        var text = searchField.text
        if ( text.length > 0 ) {
            profiles.model.command = {
                command: 'filterpublicprofiles',
                filter: {
                    $and:[
                        {
                            id:{
                                $not:{
                                    $in:exclude
                                }
                            }
                        },
                        {
                            $or:[
                                {
                                    username: {
                                        $regex: '^' + text,
                                        $options:'i'
                                    }
                                },
                                {
                                    tags: {
                                        $elemMatch: {
                                            $regex: '^' + text,
                                            $options:'i'
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            };
        } else {
            profiles.model.command = {
                command: 'filterpublicprofiles',
                filter: {
                    id:{
                        $not:{
                            $in:exclude
                        }
                    }
                }
            };
        }
        profiles.model.refresh();
    }

    property var exclude: ([])
}
