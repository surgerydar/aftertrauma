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
            /*
            ListView {
                id: legendList
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
                        text: model.label
                    }
                }
            }
            */
            Flow {
                id: legendList
                height: parent.height / 4
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16
                //
                //
                //
                //padding: 16
                spacing: 4
                flow: Flow.TopToBottom
                //
                //
                //
                Repeater {
                    model: lineChart.legend
                    Item {
                        height: 32
                        width: swatch.width + label.contentWidth + 12
                        Rectangle {
                            id: swatch
                            height: 32
                            width: 32
                            anchors.top: parent.top
                            anchors.left: parent.left
                            radius:  height / 2
                            color: lineChart.legend[index].colour
                        }
                        Text {
                            id: label
                            anchors.top: parent.top
                            anchors.left: swatch.right
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.margins: 4
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font.weight: Font.Light
                            font.family: fonts.light
                            font.pixelSize: 18
                            color: Colours.veryDarkSlate
                            text: lineChart.legend[index].label
                        }
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
            }
        }
    }
    StackView.onActivated: {
        console.log('period: ' + period );
        lineChart.period = container.period;
        lineChart.setup();
    }

    //
    //
    //
    property string period: "year" // year | month | week
}
