import QtQuick 2.0
import "colours.js" as Colours
//
// TODO: move this to ./aftertrauma/Button.qml and
// import "aftertrauma" as AfterTrauma
// then
// AfterTrauma.Button { ... }
//
Rectangle {
    id: container
    height: 48
    width: icon.paintedWidth + label.contentWidth + ( 4 * ( icon.status === Image.Ready && label.text.length > 0 ? 3 : 2 ) )
    radius: 8
    color: Colours.darkOrange
    opacity: enabled ? 1. : .5
    //
    //
    //
    Image {
        id: icon
        anchors.top: container.top
        anchors.bottom: container.bottom
        anchors.left: container.direction === "Left" ? container.left : undefined
        anchors.right: container.direction === "Right" ? container.right : undefined
        anchors.margins: 4
        fillMode: Image.PreserveAspectFit
    }
    //
    //
    //
    Text {
        id: label
        anchors.top: container.top
        anchors.bottom: container.bottom
        anchors.left: container.direction === "Left" ? icon.status === Image.Ready ? icon.right : container.left : undefined
        anchors.right: container.direction === "Right" ? icon.status === Image.Ready ? icon.left : container.right : undefined
        anchors.margins: 4
        color: Colours.almostWhite
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 24
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked : {
            container.clicked();
        }
    }
    //
    //
    //
    Behavior on width {
        NumberAnimation {
            duration: 100
        }
    }
    //
    //
    //
    signal clicked();
    //
    //
    //
    property alias textColour: label.color
    property alias colour: container.color
    property string direction: "Left"
    property alias image: icon.source
    property alias text: label.text
}
