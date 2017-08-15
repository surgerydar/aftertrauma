import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Page {
    id: container
    //
    //
    //
    header: Header {
        id: headerBlock
        title: container.title
        visible: container.title.length > 0
        backgroundColour: container.colour
    }
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        color: container.colour
        opacity: .25
    }
    //
    //
    //
    footer: Item {
        height: 64
    }
    //
    //
    //
    property alias subtitle: headerBlock.subtitle
    property color colour: Colours.darkOrange
    property alias showNavigation: headerBlock.showNavigation
    property alias validate: headerBlock.validate
}
