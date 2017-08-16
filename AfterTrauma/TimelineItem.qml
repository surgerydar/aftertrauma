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
    height: 86 //Math.max( 108, Math.min(5,values?values.length:0) * 8 * 2 )
    //
    //
    //
    AfterTrauma.Background {
        id: background
        anchors.fill: parent
        fill: Colours.slate
    }
    //
    //
    //
    Text {
        id: dateText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: notesIndicator.top
        anchors.right: notesIndicator.right
        anchors.margins: 4
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        font.weight: Font.Light
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
        visible: (images&&images.length > 0)
        image: "icons/image.png"
        backgroundColour: "transparent"
        onClicked: {
            stack.push( "qrc:///ImageManager.qml", { date: date } );
        }
    }
    AfterTrauma.Button {
        id: notesIndicator
        width: 48
        height: 48
        anchors.left: imageIndicator.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        visible: (notes&&notes.length > 0)
        image: "icons/notes.png"
        backgroundColour: "transparent"
        onClicked: {
            stack.push( "qrc:///NotesManager.qml", { date: date } );
        }
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
        topPadding: spacing
        spacing: ( height - 8 * 5 ) / 6
        //
        //
        //

        Repeater {
            model: Math.min(5,values?values.length:0) // just use five main categories
            Rectangle {
                height: 8
                width: bars.width * values[index].value
                radius: height / 2.
                color: Colours.categoryColour(index)
            }
        }
        /*
        Rectangle {
            height: 8
            width: bars.width * values[0].value
            radius: height / 2.
            color: Colours.categoryColour(0)
        }
        Rectangle {
            height: 8
            width: bars.width * values[1].value
            radius: height / 2.
            color: Colours.categoryColour(1)
        }
        Rectangle {
            height: 8
            width: bars.width * values[2].value
            radius: height / 2.
            color: Colours.categoryColour(2)
        }
        Rectangle {
            height: 8
            width: bars.width * values[3].value
            radius: height / 2.
            color: Colours.categoryColour(3)
        }
        Rectangle {
            height: 8
            width: bars.width * values[4].value
            radius: height / 2.
            color: Colours.categoryColour(4)
        }
        */
    }
    //
    //
    //
    onDateChanged: {
        refresh();
    }
    onImagesModelChanged: {
        refresh();
    }
    onNotesModelChanged: {
        refresh();
    }
    onValuesModelChanged: {
        refresh();
    }
    //
    //
    //
    function refresh() {
        console.log( 'refreshing : ' + container.date?Utils.shortDate(container.date):"" )
        var day = dailyModel.getDayAsObject(new Date(date));
        images = day.images;
        notes = day.notes;
        values = day.values;
    }
    //
    //
    //
    property var date: 0
    //
    //
    //
    property var images: []
    property var notes: []
    property var values: []

    property var imagesModel: null
    property var notesModel: null
    property var valuesModel: null

}
