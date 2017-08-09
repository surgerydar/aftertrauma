import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils
Item {
    id: container
    //
    //
    //
    height: Math.max( 86, Math.min(5,values?values.count:0) * 8 * 2 )
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        fill: Colours.darkSlate
    }
    //
    //
    //
    Text {
        id: dateText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.verticalCenter
        anchors.right: notesIndicator.right
        anchors.margins: 4
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        font.family: fonts.light
        font.pixelSize: 32
        color: Colours.almostWhite
        text: container.date?Utils.shortDate(container.date):""
    }
    //
    // Indicators
    //
    AfterTrauma.Button {
        id: imageIndicator
        width: 48
        height: 48
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 4
        visible: (images&&images.count > 0)
        image: "icons/image.png"
        backgroundColour: "transparent"
    }
    AfterTrauma.Button {
        id: notesIndicator
        width: 48
        height: 48
        anchors.left: imageIndicator.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        visible: (notes&&notes.count > 0)
        image: "icons/notes.png"
        backgroundColour: "transparent"
    }
    //
    //
    //
    Column {
        id: bars
        anchors.top: parent.top
        anchors.left: notesIndicator.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        spacing: 4
        //
        //
        //
        Repeater {
            model: Math.min(5,values?values.count:0) // just use five main categories
            Rectangle {
                height: 8
                width: bars.width * values.get(index).value
                radius: height / 2.
                color: Colours.categoryColour(index);
            }
        }
    }
    /*
    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignRight
        text: JSON.stringify(images)
    }
    */
    //
    //
    //
    property variant date: Date.now()
    property variant images: []
    property variant notes: []
    property variant values: []
}
