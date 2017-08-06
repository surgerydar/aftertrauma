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
        delegate: AfterTrauma.Button {
            height: 64
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            textSize: 24
            //textFit: Text.Fit
            text: model.title
            backgroundColour: container.colour
            radius: model.index === 0 ? [8,8,0,0] : model.index === contents.model.count - 1 ? [0,0,8,8] : [0]
            onClicked: {
                stack.push( "qrc:///Factsheet.qml", { title: container.title, subtitle: model.title, colour: container.colour, factsheet: model.factsheet });
            }
        }
    }

    StackView.onActivated: {
    }

    property alias contents: contents.model

}
