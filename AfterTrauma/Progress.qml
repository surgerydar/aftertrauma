import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "MY PROGRESS"
    subtitle: graphs.currentItem ? graphs.currentItem.title : ""
    colour: Colours.red

    SwipeView {
        id: graphs
        anchors.fill: parent
    }
    //
    //
    //
    property string period: "year" // year | month | week
}
