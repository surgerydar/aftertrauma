import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    ListView {
        id: contents
        //
        //
        //
        height: Math.min( parent.height, contentHeight )
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        //
        //
        //
        interactive: contentHeight >= parent.height
        clip: true
        spacing: 4
        //
        //
        //
        model: documentModel
        //
        //
        //
        delegate: FactsheetItem {
            anchors.left: parent.left
            anchors.right: parent.right
            textSize: 24
            text: model.title || ""
            backgroundColour: container.colour
            onClicked: {
                stack.push( "qrc:///Factsheet.qml", { title: container.title, subtitle: model.title, colour: container.colour, document: model.document });
            }
        }
        //
        //
        //
        add: Transition {
            NumberAnimation { properties: "y"; from: contents.height; duration: 250 }
        }
    }
    //
    //
    //
    footer: Item {
        height: 16
    }
    //
    //
    //
    StackView.onActivating: {
        documentModel.setFilter({ category: category });
    }
    property string category: ""

}
