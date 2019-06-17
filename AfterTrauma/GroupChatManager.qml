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
        visible: false
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
        emptyPrompt: "No active chats<br/>Add a chat to start a new conversation<br/>or<br/>find a group chat"
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
                        chatModel.openChat(model.id);
                    });
                    item.edit.connect(function() {
                        var chat = chatModel.findOne( {id:model.id} );
                        console.log( 'editing chat : ' + JSON.stringify(chat) );
                        chatEditor.show(chat, function(edited,showChat) {
                            delete chat._id; // JONS: fudge to prevent update conflict on mongo update
                            var command = {
                                command: 'groupupdatechat',
                                token: userProfile.token,
                                chat: edited,
                                show: showChat
                            };
                            //
                            //
                            //
                            chatModel.updateTagDatabase(edited);
                            //
                            //
                            //
                            chatChannel.send(command);
                            //
                            //
                            //
                            usageModel.add('chat', 'edit', 'chat' );
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
                        //
                        //
                        //
                        usageModel.add('chat', 'remove', 'chat' );
                    });
                }
            }
        }
    }
    //
    //
    //
    ProfileSearch {
        id: searchProfiles
        width: container.width
        height: container.height - ( footerItem.height * 2 )
        x: 0
        enableDirectChat: true
        onAction: {
            //
            // TODO: find existing or start new chat with selected user
            //
            //openChat( chatId, true );
            close();
        }
    }
    GroupChatSearch {
        id: searchChats
        width: container.width
        height: container.height - ( footerItem.height * 2 )
        x: 0
        onAction: {
            chatModel.openChat( chatId, true );
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
            id: searchPeople
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8
            backgroundColour: "transparent"
            image: "icons/profile_icon_white.png"
            onClicked: {
                searchChats.close();
                searchProfiles.open(false);
            }
        }
        AfterTrauma.Button {
            id: searchGroups
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: searchPeople.right
            anchors.leftMargin: 8
            backgroundColour: "transparent"
            image: "icons/group_icon_white.png"
            onClicked: {
                searchProfiles.close();
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
                    //
                    //
                    //
                    chatModel.updateTagDatabase(edited);
                    //
                    //
                    //
                    chatChannel.send(command);
                });
                //
                //
                //
                usageModel.add('chat', 'add', 'chat' );
            }
        }
    }
    //
    //
    //
    property bool onStack: false
    //
    //
    //
    StackView.onActivated: {

        if ( userProfile ) {
            chatModel.filter = { $or: [ { owner: userProfile.id }, { members: userProfile.id } ] };
        } else {
            chatModel.filter = {};
        }

        chatModel.load(); // ????
         if ( !onStack ) {
            onStack = true;
            usageModel.add('chat', 'open' );
        }
        chats.visible = true;
    }
    StackView.onDeactivated: {
        chats.visible = false;
        chatModel.filter = {};
    }
    StackView.onRemoved: {
        onStack = false;
        usageModel.add('chat', 'close' );
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
                chatModel.openChat( command.chat.id );
            }
            /* JONS: these have been moved to ChatChannel
            chatModel.add(command.chat);
            chatModel.save();
            */
        }
        onUpdateChat:{
            console.log( 'ChatManager : update chat : ' + JSON.stringify(command.chat) );
            if ( command.show ) {
                chatModel.openChat( command.chat.id );
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
                chatModel.openChat( command.chatid );
            }
        }
    }
}
