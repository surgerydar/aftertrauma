import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
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
            //anchors.left: chats.left
            //anchors.right: chats.right
            width: parent.width
            avatar: "https://aftertrauma.uk:4000/avatar/" + model.owner
            subject: model.subject
            // TODO: owner name, last message as subtitle
            onChat: {
                var properties = {
                    chatId:model.id,
                    messages:chatModel.getMessageModel(model.id)
                };
                stack.push( "qrc:///GroupChat.qml", properties);
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
                    command: 'groupremovechat',
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
    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
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
                    members: []
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
            chatModel.add(command.chat);
            chatModel.save();
        }
        onUpdateChat:{
            console.log( 'ChatManager : update chat : ' + JSON.stringify(command.chat) );
            chatModel.update({id: command.chat.id}, command.chat);
            chatModel.save();
        }
        onRemoveChat:{
            console.log( 'ChatManager : remove chat');
            chatModel.remove({id: command.chatid});
            chatModel.save();
        }
    }
}
