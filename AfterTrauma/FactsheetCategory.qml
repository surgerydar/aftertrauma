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
        anchors.margins: 16
        //
        //
        //
        interactive: contentHeight >= parent.height
        clip: true
        spacing: 4
        //
        //
        //
        model: documentModel //ListModel {}
        //
        //
        //
        delegate: FactsheetItem {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            textSize: 24
            //textFit: Text.Fit
            text: model.title || ""
            backgroundColour: container.colour
            radius: model.index === 0 ? [8,8,0,0] : model.index === contents.model.count - 1 ? [0,0,8,8] : [0]
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

    StackView.onActivating: {
        documentModel.setFilter({ category: category });
    }
    property string category: ""

}
