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
            anchors.right: parent.right
            anchors.margins: 8
            //
            //
            //
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            minimumPixelSize: 18
            fontSizeMode: Text.Fit
            font.weight: Font.Light
            font.family: fonts.light
            font.pixelSize: 32
            color: Colours.almostWhite
        }
        Text {
            id: activityText
            anchors.top: nameText.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: active ? doneCheckbox.left : parent.right
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
        AfterTrauma.Button {
            id: doneCheckbox
            height: 24
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 8
            checkable: true
            visible: false
            textSize: 18
            text: checked ? "done" : "to do"
            backgroundColour: checked ? Colours.darkGreen : Colours.red
            onCheckedChanged: {
                updateDone(checked);
            }
        }
    }
    onDoneChanged: {
        doneCheckbox.checked = done;
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
