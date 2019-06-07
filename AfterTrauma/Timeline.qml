import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    title: "TIMELINE"
    colour: Colours.slate
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
        cacheBuffer: 0
        //
        //
        //
        model: dailyModel
        //
        //
        //
        /*
        delegate: Text {
            height: 32
            anchors.left: parent?parent.left:undefined
            anchors.right: parent?parent.right:undefined
            text: Utils.shortDate(model.date)
        }
        */

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
            anchors.margins: 4
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 32
            color: Colours.almostWhite
            text: section
        }
    }
    //
    //
    //
    footer: Item {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            id: addEntry
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 8
            backgroundColour: "transparent"
            image: "icons/add.png"
            onClicked: {
                addDialog.open();
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        //dailyList.forceLayout();
    }
    //
    //
    //
    Connections {
        target: dailyModel
        onDataChanged : {
            console.log('dailyModel.onDataChanged');
            //dailyList.forceLayout();
        }
    }
}
