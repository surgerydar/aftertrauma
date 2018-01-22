import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "ABOUT"
    colour: Colours.darkOrange
    //
    //
    //
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
                model: blocks
                delegate: AfterTrauma.Block {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    type: model.type
                    media: model.content
                }
                /*
                add: Transition {
                    NumberAnimation { properties: "y"; from: contentContainer.height; duration: 250 }
                }
                */
            }
        }
    }
    //
    //
    //
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
    //
    //
    //
    Component.onCompleted: {
        pages.model.clear();
        var filter = {section: 'about'};
        console.log( 'Help : filtering by : ' + JSON.stringify( filter ) );
        documentModel.setFilter(filter);
        var count = documentModel.count;
        console.log( 'Help : appending : ' + count + ' documents' );
        for ( var i = 0; i < count; i++ ) {
            var document = documentModel.get(i);
            console.log( 'Help : appending document : ' + JSON.stringify(document));
            pages.model.append(document);
        }
    }
}
