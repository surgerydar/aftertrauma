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
        /*
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 84
        anchors.rightMargin: 8
        */
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
    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        /*
        AfterTrauma.PageIndicator {
            id: pageIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
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
        */
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            image: "icons/left_arrow.png"
            visible: contentContainer.currentIndex > 0
            onClicked: {
                contentContainer.decrementCurrentIndex();
            }
        }
        AfterTrauma.PageIndicator {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            currentIndex: contentContainer.currentIndex
            count: contentContainer.count
            interactive: true
            colour: Colours.lightSlate
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            image: "icons/right_arrow.png"
            visible: contentContainer.currentIndex < contentContainer.count - 1
            onClicked: {
                contentContainer.incrementCurrentIndex();
            }
        }
    }
    //
    //
    //
    property bool onStack: false
    StackView.onActivating: {
        pages.model.clear();
        var filter = {section: 'about'};
        console.log( 'Help : filtering by : ' + JSON.stringify( filter ) );
        documentModel.setFilter(filter);
        var count = documentModel.count;
        //console.log( 'Help : appending : ' + count + ' documents' );
        for ( var i = 0; i < count; i++ ) {
            var document = documentModel.get(i);
            //console.log( 'Help : appending document : ' + JSON.stringify(document));
            pages.model.append(document);
        }
        if ( !onStack ) {
            usageModel.add('about', 'open' );
        }
    }
    StackView.onRemoved: {
        onStack = false;
        usageModel.add('about', 'close' );
    }
    //
    //
    //
    Component.onCompleted: {
        pages.model.clear();
        var filter = {section: 'about'};
        //console.log( 'Help : filtering by : ' + JSON.stringify( filter ) );
        documentModel.setFilter(filter);
        var count = documentModel.count;
        //console.log( 'Help : appending : ' + count + ' documents' );
        for ( var i = 0; i < count; i++ ) {
            var document = documentModel.get(i);
            //console.log( 'Help : appending document : ' + JSON.stringify(document));
            pages.model.append(document);
        }
    }
}
