import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    modal: true
    focus: true
    x: 0
    y: 0
    width: appWindow.width
    height: appWindow.height
    //
    //
    //
    background: Item {
        Rectangle {
            height: 64
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: Colours.almostWhite
        }
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 68
            color: Colours.almostWhite
        }
    }
    //
    //
    //
    Item {
        id: header
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        Label {
            id: title
            anchors.fill: parent
            anchors.leftMargin: closeButton.width + 24
            anchors.rightMargin: closeButton.width + 24
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            fontSizeMode: Label.Fit
            color: Colours.veryDarkSlate
            font.pixelSize: 36
            font.weight: Font.Light
            font.family: fonts.light
            text: "INTRODUCTION"
        }
        //
        //
        //
        AfterTrauma.Button {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            image: "icons/close.png"
            onClicked: {
                container.close();
            }
        }
    }
    //
    //
    //
    SwipeView {
        id: contentContainer
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 4
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
    //
    //
    //
    AfterTrauma.PageIndicator {
        id: pageIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: contentContainer.bottom
        anchors.bottomMargin: 8
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
        id: prevButton
        anchors.verticalCenter: pageIndicator.verticalCenter
        anchors.left: parent.left
        image: "icons/left_arrow.png"
        radius: 0
        backgroundColour: Colours.veryLightSlate
        visible: contentContainer.currentIndex > 0
        onClicked: {
            contentContainer.decrementCurrentIndex();
        }
    }
    AfterTrauma.Button {
        id: nextButton
        anchors.verticalCenter: pageIndicator.verticalCenter
        anchors.right: parent.right
        image: "icons/right_arrow.png"
        radius: 0
        backgroundColour: Colours.veryLightSlate
        visible: contentContainer.currentIndex < contentContainer.count - 1
        onClicked: {
            contentContainer.incrementCurrentIndex();
        }
    }

    //
    //
    //
    Component.onCompleted: {
        pages.model.clear();
        var filter = {section: 'introduction'};
        console.log( 'Introduction : filtering by : ' + JSON.stringify( filter ) );
        documentModel.setFilter(filter);
        var count = documentModel.count;
        console.log( 'Introduction : appending : ' + count + ' documents' );
        for ( var i = 0; i < count; i++ ) {
            var document = documentModel.get(i);
            console.log( 'Introduction : appending document : ' + JSON.stringify(document));
            pages.model.append(document);
        }
    }
}
