import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 64
    //
    //
    //
    AfterTrauma.Background {
        anchors.fill: parent
        fill: Colours.darkOrange
    }
}
