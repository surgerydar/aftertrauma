import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: open ? 172 : 86
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        fill: Colours.lightGreen
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            open = !open;
        }
    }
    //
    //
    //
    Text {
        id: labelText
        height: 54
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: decorationItem.left
        anchors.margins: 16
        color: Colours.almostWhite
        font.family: fonts.light
        font.pixelSize: 32
    }
    //
    // decoration
    //
    Item {
        id: decorationItem
        width: contentWidth
        height: 54
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16
        //
        //
        //
        AfterTrauma.More {
            id: revealDecoration
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            visible: !( container.type === "number" || container.type === "switch" )
            checked: container.open
            onCheckedChanged: {
                container.open = checked;
            }
        }
        AfterTrauma.SpinBox {
            id: numberDecoration
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            visible: container.type === "number"
        }
        AfterTrauma.Switch {
            id: switchDecoration
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            visible: container.type === "switch"
        }
    }
    //
    // decoration components
    //
    //
    // editor
    //
    Item {
        id: editorItem
        height: Math.max(48, container.type === "name" ? nameEditor.contentHeight : container.type === "description" ? descriptionEditor.contentHeight : container.type === "options" ? optionsEditor.contentHeight : 0)
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: decorationItem.left
        anchors.margins: 16
        visible: false
        //
        // editor components
        //
        AfterTrauma.TextField {
            id: nameEditor
            anchors.fill: parent
            visible: container.type === "name"
            onAccepted: {
                labelText.text = text;
                container.open = false
            }
        }
        AfterTrauma.TextArea {
            id: descriptionEditor
            anchors.fill: parent
            visible: container.type === "description"
            onContentHeightChanged: {
                editorItem.height = contentHeight;
            }
        }
        ListView {
            id: optionsEditor
            anchors.fill: parent
            visible: container.type === "options"
            delegate: Text {
                padding: 8
                color: Colours.almostWhite
                font.family: fonts.light
                font.pixelSize: 24
                text: model.label
                //
                //
                //
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        labelText.text = model.label;
                        container.open = false;
                    }
                }
            }

        }
    }
    //
    //
    //
    Behavior on height {
        NumberAnimation {
            duration: 50
        }
    }
    //
    //
    //
    onOpenChanged: {
        editorItem.visible = container.open;
    }
    //
    //
    //
    property alias backgroundColour: background.fill
    property alias radius: background.radius
    property alias label: labelText.text
    property string type: "name" // "name" | "description" | "options" | "number" | "switch"
    property bool open: false
    property alias options: optionsEditor.model
}
