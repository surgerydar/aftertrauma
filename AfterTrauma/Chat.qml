import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "CHAT"
    subtitle: "Ellie"
    colour: Colours.darkPurple
    //
    //
    //
    ListView {
        id: messages
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
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
        delegate: ChatMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            from: model.from
            avatar: model.avatar || "icons/profile_icon.png"
            message: model.message
        }
        //
        //
        //
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: messages.height
                duration: 250
            }

        }
    }
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
                    messages.positionViewAtEnd();
                }
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 50
            }
        }
    }

    StackView.onActivated: {
        var data = [
                    { from: "me", message: "Hi how are you?" },
                    { from: "ellie", message: "Good thanks hbu?" },
                    { from: "me", message: "Better for a good nights sleep" },
                    { from: "ellie", message: "I'm aching all over" },
                ];
        messages.model.clear();
        data.forEach(function(datum) {
            messages.model.append(datum);
        });
    }
}
