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
    Image {
        id: image
        anchors.fill: parent
        anchors.margins: 8
        //
        //
        //
        fillMode: Image.PreserveAspectFit
    }
    //
    //
    //
    property alias source: image.source
}
