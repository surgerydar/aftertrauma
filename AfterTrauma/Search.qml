import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "SEARCH"
    colour: Colours.darkOrange
    //
    //
    //
    ListView {
        id: results
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: SearchItem {
            anchors.left: parent.left
            anchors.right: parent.right
        }
        add: Transition {
            NumberAnimation { properties: "y"; from: results.height; duration: 250 }
        }
    }
    footer: Item {
        height: 128
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.TextField {
            id: searchField
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: searchButton.left
            anchors.margins: 8
        }
        //
        //
        //
        AfterTrauma.Button {
            id: searchButton
            anchors.verticalCenter: searchField.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            image: "icons/search.png"
            backgroundColour: "transparent"
            //
            //
            //
            onClicked: {
            }
        }
     }
    //
    //
    //
    StackView.onActivated: {
    }
}
