import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    height: parent.height
    //
    //
    //
    background: AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        //opacity: .5
    }
    //
    //
    //
    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
        padding: 16
        Label {
            id: titleText
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            color: Colours.veryDarkSlate
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            font.pointSize: 36
            font.weight: Font.Light
            font.family: fonts.light
            text: "Select Dates"
        }
        //
        //
        //
        Label {
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colours.veryDarkSlate
            font.pointSize: 24
            font.weight: Font.Light
            font.family: fonts.light
            text: "from date"
        }
        //
        //
        //
        AfterTrauma.DatePicker {
            id: from
            height: 128
            width: container.width - 8
            anchors.horizontalCenter: parent.horizontalCenter
            minimumDate: container.minimumDate
            maximumDate: to.currentDate
        }
        //
        //
        //
        Label {
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colours.veryDarkSlate
            font.pointSize: 24
            font.weight: Font.Light
            font.family: fonts.light
            text: "to date"
        }
        //
        //
        //
        AfterTrauma.DatePicker {
            id: to
            height: 128
            width: container.width - 8
            anchors.horizontalCenter: parent.horizontalCenter
            minimumDate: from.currentDate
            maximumDate: container.maximumDate
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
                text: "cancel"
                textColour: Colours.veryDarkSlate
                onClicked: {
                    container.close();
                }
            }
            AfterTrauma.Button {
                text: "ok"
                textColour: Colours.veryDarkSlate
                onClicked: {
                    container.close();
                    if ( callback ) {
                        callback( from.currentDate, to.currentDate );
                    }
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "y"; from: parent.height; to: 0 }
    }

    exit: Transition {
        NumberAnimation { property: "y"; from: 0; to: parent.height }
    }
    //
    //
    //
    function show( callback, title, fromDate, toDate ) {
        blockUpdates = true;

        container.callback = callback;
        titleText.text = title;

        if ( fromDate ) {
            from.currentDate = fromDate;
        } else {
            from.currentDate = new Date();
        }

        if ( toDate ) {
            to.currentDate = toDate;
        } else {
            to.currentDate = new Date();
        }

        blockUpdates = false;
        from.updateUI();
        to.updateUI();
        open();
    }
    //
    //
    //
    property bool blockUpdates: false
    property var callback: null
    property date minimumDate: globalMinimumDate
    property date maximumDate: globalMaximumDate
}
