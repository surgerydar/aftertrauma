import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0
import "colours.js" as Colours

Item {
    id: container
    height: ( width * ( image.sourceSize.height / image.sourceSize.width ) ) + 64
    //
    //
    //
    Image {
        id: image
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 64
        source: "icons/" + partName + "_" + ( checked ? "on" : "off" ) + ".png"
        fillMode: Image.PreserveAspectFit
    }
    //
    //
    //
    Label {
        id: label
        height: 64
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter
        color: Colours.veryDarkSlate
        font.family: fonts.light
        font.pointSize: 18
        fontSizeMode: Label.Fit
        minimumPointSize: 9
    }
    //
    //
    //
    property bool checked: false
    property string partName: ""
    property alias label: label.text
}

