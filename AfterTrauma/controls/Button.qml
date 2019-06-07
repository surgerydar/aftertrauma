import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Button {
    id: control
    height: 48
    //implicitWidth: ( icon.status === Image.Ready ? (( 48. / icon.implicitHeight ) * icon.implicitWidth ) : 0 ) + label.contentWidth + ( 4 * ( icon.status === Image.Ready && label.text.length > 0 ? 3 : 2 ) )
    //implicitWidth: icon.width + label.contentWidth + ( spacing * ( icon.status === Image.Ready > 0 && label.text.length > 0 ? 3 : 2 ) )
    width: calculateWidth()
    opacity: enabled ? 1. : .5
    spacing: 4
    //
    //
    //
    contentItem: Item {
        id: content
        anchors.fill: control
        //
        //
        //
        Image {
            id: icon
            anchors.top: content.top
            anchors.bottom: content.bottom
            anchors.left: control.direction === "Left" ? content.left : undefined
            anchors.right: control.direction === "Right" ? content.right : undefined
            anchors.margins: spacing
            fillMode: Image.PreserveAspectFit
            onStatusChanged: {
                control.width = calculateWidth();
            }
        }
        //
        //
        //
        Text {
            id: label
            anchors.top: content.top
            anchors.bottom: content.bottom
            anchors.left: control.direction === "Left" && icon.status === Image.Ready ? icon.right : content.left
            anchors.right: control.direction === "Right" && icon.status === Image.Ready ? icon.left : content.right
            anchors.margins: spacing
            color: Colours.almostWhite
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter //control.direction === "Left" ? Text.AlignLeft : Text.AlignRight
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 24
            text: control.text
        }
    }
    //
    //
    //
    background: Background {
        id: background
        anchors.fill: control
        radius: [8]
        fill: Qt.rgba(0,0,0,0)
    }
    //
    //
    //
    function calculateWidth() {
        return icon.width + label.contentWidth + 4 + ( spacing * ( icon.status === Image.Ready > 0 && label.text.length > 0 ? 3 : 2 ) );
    }
    //
    //
    //
    property alias radius: background.radius
    property alias borderColour: background.stroke
    property alias borderWidth: background.lineWidth
    property alias image: icon.source
    property alias backgroundColour: background.fill
    property alias textSize: label.font.pointSize
    property alias textColour: label.color
    property alias textVerticalAlignment: label.verticalAlignment
    property alias textHorizontalAlignment: label.horizontalAlignment
    property alias textFit: label.fontSizeMode
    property string direction: "Left"
}
