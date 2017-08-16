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
            //images: model.images
            //notes: model.notes
            //values: model.values
            //
            //
            //
            Component.onCompleted: {
                itemCount++;
                console.log('timeline item created : ' + itemCount );
            }
            Component.onDestruction: {
                itemCount--;
                console.log('timeline item destroyed : ' + itemCount );
            }
        }

        //
        //
        //
        section.property: "year"
        section.delegate: Text {
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            font.weight: Font.Light
            font.family: fonts.light.name
            font.pixelSize: 32
            color: Colours.almostWhite
            text: section
        }
        //
        //
        //
        onCountChanged: {
            console.log( 'timeline ListView.count : ' + count + 'ListView.model.count : ' + model.count );
        }
    }
    //
    //
    //
    StackView.onActivated: {
        dailyList.update();
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
    property int itemCount: 0
}
