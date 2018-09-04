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
    AfterTrauma.EditableList { //ListView {
        id: chats
        anchors.fill: parent
        anchors.bottomMargin: 4
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
        emptyPrompt: "No active chat's<br/>Add a chat to start a new conversation<br/>or<br/>find a group chat"
        //
        //
        //
        delegate: Component {
            Loader {
                source: "GroupChatItem.qml"
                onLoaded: {
                    //
                    // set properties
                    //
                    item.width = chats.width;
                    item.avatar = "https://aftertrauma.uk:4000/avatar/" + model.owner + '?width=56&height=56'
                    item.owner = model.owner
                    item.subject = model.subject
                    item.contentEditable = model.owner === userProfile.id
                    item.deleteLabel = model.owner === userProfile.id ? "Delete" : "Leave"
                    item.count = unreadChatsModel.totalUnread > 0 ? unreadChatsModel.getUnreadCountText(model.id) : ""
                    item.members = model.members
                    //
                    // connect to signals
                    //
                    item.chat.connect(function() {
                        openChat(model.id);
                    });
                    item.edit.connect(function() {
                        var chat = chatModel.get( index );
                        console.log( 'editing chat : ' + JSON.stringify(chat) );
                        chatEditor.show(chat, function(edited,showChat) {
                            delete chat._id; // JONS: fudge to prevent update conflict on mongo update
                            var command = {
                                command: 'groupupdatechat',
                                token: userProfile.token,
                                chat: edited,
                                show: showChat
                            };
                            chatChannel.send(command);
                        });
                    });
                    item.remove.connect(function() {
                        var command = {
                            command: model.owner === userProfile.id ? 'groupremovechat' : 'groupleavechat',
                            token: userProfile.token,
                            userid: userProfile.id,
                            chatid: model.id
                        };
                        chatChannel.send(command);
                    });
                }
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
            openChat( chatId, true );
            close();
        }
    }
    //
    //
    //
    footer: Rectangle {
        id: footerItem
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        color: Colours.darkPurple
        //
        //
        //
        AfterTrauma.Button {
            id: searchChat
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8
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
            if ( command.show ) {
                openChat( command.chat.id );
            }
            /* JONS: these have been moved to ChatChannel
            chatModel.add(command.chat);
            chatModel.save();
            */
        }
        onUpdateChat:{
            console.log( 'ChatManager : update chat : ' + JSON.stringify(command.chat) );
            if ( command.show ) {
                openChat( command.chat.id );
            }
            /* JONS: these have been moved to ChatChannel
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
        onJoinChat: {
            console.log( 'ChatManager : join chat : ' + JSON.stringify(command.chatid) );
            if ( command.show ) {
                openChat( command.chatid );
            }
        }
    }
    //
    //
    //
    function openChat( chatId, join ) {
        var chat = chatModel.findOne({id:chatId});
        var command;
        if ( chat ) {
            if ( chat.owner !== userProfile.id ) {
                //
                // check if we have accepted invite
                //
                if ( chat.active === undefined || chat.active.indexOf(userProfile.id) < 0 ) { // TODO: remove legacy chat support

                    if ( chat.invited !== undefined && chat.invited.indexOf(userProfile.id) >= 0 ) { // TODO: remove legacy chat support
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
                        console.log( 'GroupChatManager.openChat : unable to load chat ' + JSON.stringify(chat ) );
                        return;
                    }
                }
            }
            console.log( 'GroupChatManager.openChat : loading chat : ' + chat.subject );
            var properties = {
                chatId:chat.id,
                messages:chatModel.getMessageModel(chat.id),
                subject: chat.subject
            };
            stack.push( "qrc:///GroupChat.qml", properties);
        } else if ( join ) {
            //
            // join chat
            //
            command = {
                command: 'groupjoinchat',
                token: userProfile.token,
                chatid: chatId,
                userid: userProfile.id,
                show: true
            };
            chatChannel.send(command);
        }
    }
}
