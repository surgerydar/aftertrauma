import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.EditableListItem {
    id: container
    //
    //
    //
    //height: 86
    height: width / 4.
    //
    //
    //
    contentItem: Item {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //
        //
        //
        AfterTrauma.Background {
            id: background
            anchors.fill: parent
            fill: Colours.lightGreen
        }
        //
        //
        //
        Text {
            id: nameText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.verticalCenter
            anchors.right: active ? doneCheckbox.left : parent.right
            anchors.margins: 8
            //
            //
            //
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            minimumPointSize: 12
            fontSizeMode: Text.Fit
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 32
            color: Colours.almostWhite
        }
        Text {
            id: activityText
            anchors.top: nameText.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 8
            //
            //
            //
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            minimumPixelSize: 12
            font.weight: Font.Light
            font.family: fonts.light
            font.pixelSize: 24
            color: Colours.almostWhite
        }
        //
        //
        //
        Label {
            id: doneCheckbox
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 8
            visible: false
            padding: 4
            font.pointSize: 18
            text: done ? "done" : "to do"
            color: Colours.almostWhite
            background: Rectangle {
                radius: 4
                color: done ? Colours.darkGreen : Colours.red
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    updateDone(done?false:true);
                }
            }
        }
    }
    //
    //
    //
    signal updateDone( bool isDone )
    //
    //
    //
    property alias name: nameText.text
    property alias activity: activityText.text
    property bool done: false
    property alias active: doneCheckbox.visible

}
