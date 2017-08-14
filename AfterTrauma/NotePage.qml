import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils
Page {
    id: container
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        color: Colours.blue
    }
    //
    //
    //
    AfterTrauma.TextArea {
        id: noteText
        //
        //
        //
        anchors.fill: parent
        anchors.bottomMargin: 64
        padding: 24
        //
        //
        //
        font.pixelSize: 32
        wrapMode: TextArea.Wrap
        placeholderText: "Type a note"
    }
    //
    //
    //
    property alias note: noteText.text
}
