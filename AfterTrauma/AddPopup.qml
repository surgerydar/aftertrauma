import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    //
    //
    //
    background: AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.veryDarkSlate
        //opacity: .5
    }
    //
    //
    //
    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 32
        padding: 32
        //
        //
        //
        Label {
            height: 64
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colours.almostWhite
            font.pointSize: 36
            font.weight: Font.Light
            font.family: fonts.light
            text: "Add Diary Entry"
        }
        //
        //
        //
        AfterTrauma.DatePicker {
            id: date
            height: 128
            width: container.width - 8
            anchors.horizontalCenter: parent.horizontalCenter
        }
        //
        //
        //
        Row {
            height: 64
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 32
            //
            //
            //
            AfterTrauma.Button {
                text: "image"
                onClicked: {
                    // add images
                    date.currentDate.setHours(0,0,0);
                    stack.push( "qrc:///ImageManager.qml", { date: date.currentDate.getTime() } );
                    container.close();
                }
            }
            AfterTrauma.Button {
                text: "note"
                onClicked: {
                    // add notes
                    date.currentDate.setHours(0,0,0);
                    stack.push( "qrc:///NotesManager.qml", { date: date.currentDate.getTime() } );
                    container.close();
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "y"; from: parent.height; to: parent.height - implicitHeight }
    }

    exit: Transition {
        NumberAnimation { property: "y"; from: parent.height - implicitHeight; to: parent.height }
    }
}
