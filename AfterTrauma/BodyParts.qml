import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    implicitHeight: parts.contentHeight
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: Colours.almostWhite
    }
    //
    //
    //
    GridView {
        id: parts
        anchors.fill: parent
        cellWidth: width / 3
        cellHeight: ( cellWidth * 1.359805510534846 ) + 64
        clip: true
        model: bodyPartModel
        delegate: BodyPart {
            width: parts.width / 3
            label: model.name
            partName: model.canonical
            checked: model.selected
            //
            //
            //
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    checked = !checked;
                    parts.model.setSelected(partName,checked);
                }
            }
        }
    }
}
