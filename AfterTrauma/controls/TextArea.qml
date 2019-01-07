import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

TextArea {
    id: container
    height: 48
    color: Colours.veryDarkSlate
    padding: 8
    font.pointSize: 24
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        radius: 4
        color: Colours.veryLightSlate
        border.color: "transparent"
    }
    Label {
        anchors.centerIn: parent
        visible: showPlaceholderPrompt && container.text.length === 0 && !container.activeFocus
        color: Colours.slate
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        font.pointSize: 24
        text: container.placeholderText
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
        text: "x"
        onClicked: {
            Qt.inputMethod.hide();
        }

    }
    //
    //
    //
    onActiveFocusChanged: {
        doneButton.visible = activeFocus;
    }
    property bool showPlaceholderPrompt: false
}
