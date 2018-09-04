import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Flickable {
    id: container
    contentHeight: textArea.height + ( textArea.padding * 2 ) // TODO: fix binding loop
    clip: true
    //
    //
    //
    TextArea {
        id: textArea
        width: container.width
        height: Math.max(contentHeight+padding*2,container.height)
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

        Button {
            id: doneButton
            anchors.bottom: parent.top
            anchors.right: parent.right
            visible: false
            text: "done"
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
    property alias text: textArea.text
    property alias font: textArea.font
    property alias placeholderText: textArea.placeholderText
}
