import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    implicitHeight: parts.contentHeight + 64
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
        //anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: bodyPrompt.top
        anchors.right: parent.right
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
                    partSelected( model.name, checked );
                }
            }
        }
    }
    //
    //
    //
    AfterTrauma.Label {
        id: bodyPrompt
        height: calculateHeight()
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        Behavior on height {
            NumberAnimation { duration: 250 }
        }
        background: Rectangle {
            color: Colours.veryLightSlate
        }
        function calculateHeight() {
            return bodyPartModel.hasSelected() ? 64 : 0;
        }
    }
    Connections {
        target: bodyPartModel
        onDataChanged: {
            bodyPrompt.height = bodyPrompt.calculateHeight();
        }
    }

    //
    //
    //
    signal partSelected( string name, bool selected )
    //
    //
    //
    property alias prompt: bodyPrompt.text
}
