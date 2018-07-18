import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    title: "CHATS"
    colour: Colours.darkPurple
    //
    //
    //
    ListView {
        id: chats
        anchors.fill: parent
        anchors.bottomMargin: 8
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: chatModel
        //
        //
        //
        /* TODO: work out sections for group chat
        section.property: "status"
        section.delegate: Text {
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            font.weight: Font.Light
            font.family: fonts.light
            font.pixelSize: 32
            font.capitalization: Font.Capitalize
            color: Colours.almostWhite
            text: section
        }
        */
        //
        //
        //
        delegate: GroupChatItem {
            width: chats.width
            avatar: "https://aftertrauma.uk:4000/avatar/" + model.owner
            owner: model.owner
            subject: model.subject
            contentEditable: model.owner === userProfile.id
            deleteLabel: model.owner === userProfile.id ? "Delete" : "Leave"
            count: unreadChatsModel.totalUnread > 0 ? unreadChatsModel.getUnreadCountText(model.id) : ""
            members: model.members
            // TODO: owner name, last message as subtitle
            // TODO: indicator for invite
            // TODO: list of active members
            onChat: {
                openChat(index);
            }
            onEdit: {
                var chat = chatModel.get( index );
                console.log( 'editing chat : ' + JSON.stringify(chat) );
                chatEditor.show(chat, function(edited) {
                    delete chat._id; // JONS: fudge to prevent update conflict on mongo update
                    var command = {
                        command: 'groupupdatechat',
                        token: userProfile.token,
                        chat: edited
                    };
                    chatChannel.send(command);
                });
            }
            onRemove: {
                var command = {
                    command: model.owner === userProfile.id ? 'groupremovechat' : 'groupleavechat',
                    token: userProfile.token,
                    userid: userProfile.id,
                    chatid: model.id
                };
                chatChannel.send(command);
            }
        }
    }
    //
    //
    //
    GroupChatSearch {
        id: searchChats
        width: container.width
        height: container.height - ( footerItem.height * 2 )
        x: 0
        onAction: {
            openChat( index );
            close();
        }
    }
    //
    //
    //
    footer: Item {
        id: footerItem
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            id: searchChat
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: addChat.left
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/search.png"
            onClicked: {
                searchChats.open();
            }
        }
        AfterTrauma.Button {
            id: addChat
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                //
                // create new chat
                //
                var chat = {
                    id: GuidGenerator.generate(),
                    owner: userProfile.id,
                    subject: "",
                    "public": false,
                    members: [],
                    messages: []
                };
                chatEditor.show(chat, function(edited) {
                    var command = {
                        command: 'groupcreatechat',
                        token: userProfile.token,
                        chat: edited
                    };
                    chatChannel.send(command);
                });

            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        chatModel.load();
    }
    StackView.onDeactivated: {
    }
    //
    //
    //
    Connections {
        target: chatChannel
        onGetUserChats:{
            // TODO:
        }

        onCreateChat:{
            console.log( 'ChatManager : create chat');
            /*
            chatModel.add(command.chat);
            chatModel.save();
            */
        }
        onUpdateChat:{
            console.log( 'ChatManager : update chat : ' + JSON.stringify(command.chat) );
            /*
            chatModel.update({id: command.chat.id}, command.chat);
            chatModel.save();
            */
        }
        onRemoveChat:{
            console.log( 'ChatManager : remove chat');
            /*
            chatModel.remove({id: command.chatid});
            chatModel.save();
            */
        }
    }
    //
    //
    //
    function openChat( index ) {
        var chat = chatModel.get(index);
        if ( chat ) {
            if ( chat.owner !== userProfile.id ) {
                //
                // check if we have accepted invite
                //
                if ( chat.active.indexOf(userProfile.id) < 0 ) {
                    var command;
                    if ( chat.invited.indexOf(userProfile.id) >= 0 ) {
                        //
                        // invited so accept
                        //
                        command = {
                            command: 'groupacceptinvite',
                            token: userProfile.token,
                            chatid: chat.id,
                            userid: userProfile.id
                        };

                    } else if ( chat["public"] ) {
                        console.log( 'GroupChatManager.openChat : joining public chat : ' + chat.id );
                        //
                        // public so join
                        //
                        command = {
                            command: 'groupjoinchat',
                            token: userProfile.token,
                            chatid: chat.id,
                            userid: userProfile.id
                        };
                    }
                    if ( command ) {
                        chatChannel.send(command);
                    } else {
                        return;
                    }
                }
            }

            var properties = {
                chatId:chat.id,
                messages:chatModel.getMessageModel(chat.id),
                subject: chat.subject
            };
            stack.push( "qrc:///GroupChat.qml", properties);
        }
    }
}
