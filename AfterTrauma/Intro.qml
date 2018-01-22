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
        id: contentContainer
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 84
        anchors.rightMargin: 8
        clip: true
        //
        //
        //
        Repeater {
            id: pages
            anchors.fill: parent
            model: ListModel {}
            delegate: ListView {
                id: page
                //anchors.fill: pages
                //model: model.blocks
                model: blocks
                delegate: AfterTrauma.Block {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    type: model.type
                    media: model.content
                }
                add: Transition {
                    NumberAnimation { properties: "y"; from: contentContainer.height; duration: 250 }
                }
            }
        }
    }
    PageIndicator {
        id: pageIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: contentContainer.bottom
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
        currentIndex: contentContainer.currentIndex
        count: contentContainer.count
        onCurrentIndexChanged: {
            if ( currentIndex != contentContainer.currentIndex ) contentContainer.currentIndex = currentIndex;
        }
    }
    AfterTrauma.Button {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 8
        text: "PREV"
        image: "icons/left_arrow.png"
        direction: "Left"
        enabled: contentContainer.currentIndex > 0
        onClicked : {
            if( contentContainer.currentIndex > 0 ) contentContainer.currentIndex--;
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
        enabled: contentContainer.currentIndex < contentContainer.count - 1
        onClicked: {
            if( contentContainer.currentIndex < contentContainer.count - 1 ) contentContainer.currentIndex++;
        }
    }
    //
    //
    //
    Component.onCompleted: {
        pages.model.clear();
        documentModel.setFilter({section: 'introduction'});
        var count = documentModel.count;
        for ( var i = 0; i < count; ++i ) {
            var document = documentModel.get(i);
            pages.model.append(document);
        }
    }
}
