import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Flickable {
    id: container
    contentHeight: textArea.height + ( textArea.padding * 2 ) // TODO: fix binding loop
    clip: true
    interactive: contentHeight > height
    //
    //
    //
    TextArea {
        id: textArea
        width: container.width
        //height: Math.max(contentHeight+padding*2,container.height)
        color: Colours.veryDarkSlate
        padding: 8
        wrapMode: TextArea.Wrap
        font.pointSize: 24
        background: Rectangle {
            anchors.fill: parent
            radius: 4
            color: Colours.veryLightSlate
            border.color: "transparent"
        }
        //
        //
        //
        Button {
            id: doneButton
            width: 16
            height: 16
            anchors.top: parent.top
            anchors.right: parent.right
            visible: false
            font.pointSize: 10
            text: "v"
            onClicked: {
                Qt.inputMethod.hide();
            }
        }
        //
        //
        //
        onCursorRectangleChanged: {
            container.ensureVisible(cursorRectangle)
        }
        onActiveFocusChanged: {
            doneButton.visible = activeFocus;
        }
        onContentHeightChanged: {
           height = Math.max(contentHeight+padding*2,container.height);
        }
    }
    //
    //
    //
    function ensureVisible(r) {
        if (contentX >= r.x)
            contentX = r.x;
        else if (contentX+width <= r.x+r.width)
            contentX = r.x+r.width-width;
        if (contentY >= r.y)
            contentY = r.y;
        else if (contentY+height <= r.y+r.height)
            contentY = r.y+r.height-height;
    }
    //
    //
    //
    Component.onCompleted: {
        textArea.height = Math.max(textArea.contentHeight+textArea.padding*2,height);
    }

    //
    //
    //
    property alias text: textArea.text
    property alias font: textArea.font
    property alias placeholderText: textArea.placeholderText
}
