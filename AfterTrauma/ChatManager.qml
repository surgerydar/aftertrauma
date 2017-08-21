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
        spacing: 8
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: ChatItem {
            anchors.left: parent.left
            anchors.right: parent.right
            to: model.to
        }
    }
    //
    //
    //
    footer: Item {
        height: 128
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            id: addChat
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                stack.push("qrc:///ProfileList.qml");
            }
        }
    }

    StackView.onActivated: {
        var data = [
                    { to: "jack", message: "Hi how are you?" },
                    { to: "ellie", message: "Good thanks hbu?" }                ];
        chats.model.clear();
        data.forEach(function(datum) {
            chats.model.append(datum);
        });
        //
        //
        //
        chatChannel.open();

    }
    StackView.onDeactivated: {

        chatChannel.close();
    }

    //
    //
    //
    WebSocketChannel {
        id: chatChannel

    }
}
