import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "TIMELINE"
    colour: Colours.darkSlate
    //
    //
    //
    ListView {
        id: dailyList
        //
        //
        //
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 8
        //
        //
        //
        model: dailyModel
        //
        //
        //
        delegate: TimelineItem {
            anchors.left: parent?parent.left:undefined
            anchors.right: parent?parent.right:undefined
            date: model.date
            images: model.images
            notes: model.notes
            values: model.values
        }
        //
        //
        //
        section.property: "year"
        section.delegate: Text {
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: fonts.light.name
            font.pixelSize: 32
            color: Colours.almostWhite
            text: section
        }
    }
    //
    //
    //
    StackView.onActivated: {
    }
    //
    //
    //
    Connections {
        target: dailyModel
        onUpdated : {
            dailyList.update();
        }
    }
}
