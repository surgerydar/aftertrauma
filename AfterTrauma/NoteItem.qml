import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 86 //Math.max(64,Math.min(86,image.sourceHeight))
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        fill: Colours.blue
    }
    //
    //
    //
    Text {
        id: text
        anchors.fill: parent
        anchors.margins: 8
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        minimumPixelSize: 18
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 32
        color: Colours.almostWhite
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            stack.push( 'qrc:///NoteEditor.qml', { date: date, note: note } );
        }
    }
    //
    //
    //
    property alias note: text.text
    property var date: Date.now()
}
