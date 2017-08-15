import QtQuick 2.7
import QtQuick.Controls 2.1

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
    /*
    //
    //
    //
    footer: Item {
        height: Math.max( addMessage.height, messageText.contentHeight ) + 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.TextArea {
            id: messageText
            height: contentHeight + 16
            anchors.top: parent.top
            anchors.left: parent.left
            //anchors.bottom: parent.bottom
            anchors.right: addMessage.left
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            anchors.bottomMargin: 28
        }
        AfterTrauma.Button {
            id: addMessage
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                if ( messageText.text.length > 0 ) {
                    messages.model.append( { from: "me", message: messageText.text } );
                    messageText.text = "";
                }
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 50
            }
        }
    }
    */
    StackView.onActivated: {
        var data = [
                    { to: "jack", message: "Hi how are you?" },
                    { to: "ellie", message: "Good thanks hbu?" }                ];
        chats.model.clear();
        data.forEach(function(datum) {
            chats.model.append(datum);
        });
    }
}
