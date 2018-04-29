import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: open ? labelText.height + editorItem.height + 48 : labelText.height + 32
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
            if ( !( container.type === "number" || container.type === "switch" ) ) {
                open = !open;
                if ( open ) container.selected();
            }
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
        clip: true
        color: Colours.almostWhite
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        minimumPixelSize: 14
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 32
    }
    //
    // decoration
    //
    Item {
        id: decorationItem
        width: container.type === "number" ? numberDecoration.width : container.type === "switch" ? switchDecoration.width : revealDecoration.width
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
            enabled: false
        }
        AfterTrauma.SpinBox {
            id: numberDecoration
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            visible: container.type === "number"
            value: 1
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
        height: Math.max(64, (container.type === "name" ? nameEditor.contentHeight : container.type === "description" ? descriptionEditor.contentHeight : container.type === "options" ? optionsEditor.contentHeight : 0 ) + 16 )
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
            placeholderText: "Type name for activity"
            onAccepted: {
                labelText.text = text;
                container.open = false
            }
            onContentHeightChanged: {
                if( visible ) editorItem.height = contentHeight + 16;
            }
        }
        AfterTrauma.TextArea {
            id: descriptionEditor
            anchors.fill: parent
            visible: container.type === "description"
            placeholderText: "Type description of activity"
            wrapMode: Text.WordWrap
            onContentHeightChanged: {
                if ( visible ) editorItem.height = contentHeight + 16;
            }
        }
        ListView {
            id: optionsEditor
            /*
            anchors.left: editorItem.left
            anchors.bottom: editorItem.bottom
            anchors.right: editorItem.right
            */
            anchors.fill: parent
            clip: true
            visible: container.type === "options"
            delegate: Text {
                height: 32
                anchors.left: parent.left
                anchors.right: parent.right
                color: Colours.almostWhite
                font.weight: Font.Light
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
        if ( open ) {
            if( type === "description" && sourceText.length > 0 ) descriptionEditor.text = sourceText;
            if( type === "name" && sourceText.length > 0 ) nameEditor.text = sourceText;
        } else {
            if( type === "description" && descriptionEditor.text.length > 0 ) labelText.text = descriptionEditor.text;
            if( type === "name" && nameEditor.text.length > 0 ) labelText.text = nameEditor.text;
        }
    }
    //
    //
    //
    signal selected();
    //
    //
    //
    property alias backgroundColour: background.fill
    property alias radius: background.radius
    property alias label: labelText.text
    property string type: "name" // "name" | "description" | "options" | "number" | "switch"
    property bool open: false
    property alias options: optionsEditor.model
    property alias on: switchDecoration.checked
    property alias value: numberDecoration.value
    property string sourceText: ""
}
