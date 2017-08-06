import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    //width: parent.width
    //height: parent.height
    //padding: 32
    modal: true
    focus: true
    //
    //
    //
    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: 16
        color: Colours.almostWhite
    }
    SwipeView {
        id: content
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 84
        anchors.rightMargin: 8
        clip: true
        Item {
            Text {
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: Text.WordWrap
                text: "Welcome to the After Trauma app, our tool to help you recover from traumatic injury. (Image of head?) We are clinical trauma specialists at Queen Mary University, steered by a team of patient advisors."
            }
        }
        Item {
            Text {
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: Text.WordWrap
                text: "This app will help you to set goals and track your recovery progress by using quick to use questionnaires adding diary notes and images. (Image of goal tracking)"
            }
        }
        Item {
            Text {
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: Text.WordWrap
                text: "Stuff about factsheets (related image)"
            }
        }
        Item {
            Text {
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: Text.WordWrap
                text: "stuff about chat (related image) "
            }
        }
        Item {
            Text {
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: Text.WordWrap
                text: "Invite to register and reasons to register (related image) "
            }
        }
    }
    PageIndicator {
        id: pageIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: content.bottom
        delegate: Rectangle {
            implicitWidth: 16
            implicitHeight: 16

            radius: width / 2
            color: index === pageIndicator.currentIndex ? Colours.lightSlate : "transparent"
            border.color: Colours.lightSlate
        }
        //
        //
        //
        interactive: true
        currentIndex: content.currentIndex
        count: content.count
        onCurrentIndexChanged: {
            if ( currentIndex != content.currentIndex ) content.currentIndex = currentIndex;
        }
    }
    AfterTrauma.Button {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 8
        text: "PREV"
        image: "icons/left_arrow.png"
        direction: "Left"
        enabled: content.currentIndex > 0
        onClicked : {
            if( content.currentIndex > 0 ) content.currentIndex--;
        }
    }
    AfterTrauma.Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 8
        text: "SKIP INTRO"
        image: "icons/close_circle.png"
        direction: "Left"
        onClicked : {
            container.close();
        }
    }
    AfterTrauma.Button {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        text: "NEXT"
        image: "icons/right_arrow.png"
        direction: "Right"
        enabled: content.currentIndex < content.count - 1
        onClicked: {
            if( content.currentIndex < content.count - 1 ) content.currentIndex++;
        }
    }
}
