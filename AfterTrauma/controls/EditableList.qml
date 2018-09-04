import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours
import "../controls" as AfterTrauma

Item {
    id: container
    //
    //
    //
    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        spacing: 4
    }
    //
    //
    //
    AfterTrauma.Label {
        id: emptyPromptLabel
        anchors.verticalCenter: listView.verticalCenter
        anchors.left: listView.left
        anchors.right: listView.right
        anchors.margins: 8
        visible: listView.count === 0
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        wrapMode: Label.WordWrap
        color: Colours.almostWhite
        text: "No Data"
    }
    //
    //
    //
    property alias list: listView
    property alias count: listView.count
    property alias model: listView.model
    property alias delegate: listView.delegate
    property alias spacing: listView.spacing
    property alias section: listView.section
    property alias emptyPrompt: emptyPromptLabel.text
    property bool editable: listView.count > 0
}

