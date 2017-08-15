import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Image {
    width: 48
    height: 48
    fillMode: Image.PreserveAspectFit
    source: checked ? "../icons/less_arrow.png" : "../icons/more_arrow.png"
    //
    //
    //
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            checked = !checked;
        }
    }
    //
    //
    //
    property alias enabled: mouseArea.enabled
    property bool checked: false
}
