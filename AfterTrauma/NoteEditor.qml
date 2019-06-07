import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    title: Utils.shortDate(date)
    colour: Colours.blue
    //
    //
    //
    AfterTrauma.TextArea {
        id: text
        anchors.fill: parent
        anchors.margins: 16
        placeholderText: "enter note"
    }
    //
    //
    //
    property var date: Date.now()
    property alias note: text.text
}
