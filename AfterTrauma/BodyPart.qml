import QtQuick 2.7
import SodaControls 1.0

Image {
    id: container
    source: partName + "_" + ( checked ? "ON" : "OFF" ) + ".png"
    fillMode: Image.PreserveAspectFit
    property bool checked: false
    property string partName: ""
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            checked = !checked;
        }
    }
}
