import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Switch {
    id: control
    //
    //
    //
    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? Colours.darkGreen : Colours.almostWhite
        border.color: Colours.lightSlate

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 26
            height: 26
            radius: 13
            color: Colours.almostWhite
            border.color: Colours.slate
        }
    }
}
