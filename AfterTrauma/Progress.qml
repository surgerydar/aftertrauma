import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    title: "MY PROGRESS"
    subtitle: lineChart.period //graphs.currentItem ? graphs.currentItem.title : ""
    colour: Colours.red

    SwipeView {
        id: graphs
        anchors.fill: parent
        //
        //
        //
        Page {
            //
            //
            //
            ListView {
                id: legendList
                height: parent.height / 3
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16
                spacing: 4
                model: ListModel {}
                delegate: ItemDelegate {
                    height: 32
                    anchors.left: parent.left
                    anchors.right: parent.right
                    Rectangle {
                        id: swatch
                        height: 32
                        width: 32
                        anchors.top: parent.top
                        anchors.left: parent.left
                        radius:  height / 2
                        color: model.colour
                    }
                    Text {
                        anchors.top: parent.top
                        anchors.left: swatch.right
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.margins: 4
                        text: model.name
                    }
                }
            }
            //
            //
            //
            LineChart {
                id: lineChart
                anchors.top: legendList.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 16

                period: container.period
                onLegendChanged: {
                    legendList.model.clear();
                    legend.forEach(function(entry) {
                        legendList.model.append(entry);
                    });
                }
            }
        }
    }
    StackView.onActivated: {
        lineChart.period = "year"
        lineChart.setup();
    }

    //
    //
    //
    property string period: "year" // year | month | week
}
