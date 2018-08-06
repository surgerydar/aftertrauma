import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils
import SodaControls 1.0

AfterTrauma.Page {
    id: container
    title: "MY PROGRESS"
    //subtitle: lineChart.period //graphs.currentItem ? graphs.currentItem.title : ""
    colour: Colours.almostWhite

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
            //
            //
            //
            NewLineChart {
            //LineChart {
                id: lineChart
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.verticalCenter
                //anchors.margins: 16
            }
            //
            //
            //
            AfterTrauma.Button {
                id: previousButton
                anchors.top: parent.verticalCenter
                anchors.topMargin: 4
                anchors.left: parent.left

                image: "icons/left_arrow.png"
                backgroundColour: Colours.veryLightSlate
                radius: [0]
                direction: "Right"
                enabled: dailyModel.indexOfFirstDayBefore(lineChart.startDate) < dailyModel.count -1;
                onClicked: {
                    var year    = lineChart.startDate.getFullYear();
                    var month   = lineChart.startDate.getMonth();
                    var day     = lineChart.startDate.getDate();
                    switch(lineChart.period) {
                    case "year" :
                        year--;
                        lineChart.startDate = new Date( year,0,1);
                        lineChart.endDate = new Date( year,11,31);
                        lineChart.gridSize = 12;
                        break;
                    case "month" :
                        month--;
                        if ( month < 0) {
                            month = 11;
                            year--;
                        }
                        lineChart.startDate = new Date( year, month, 1 );
                        lineChart.endDate = new Date( year, month, Utils.getLastDate(lineChart.startDate));
                        lineChart.gridSize = 0;
                        break;
                    case "week" :
                        var newStart = lineChart.startDate;
                        newStart.setDate(day-7)
                        lineChart.startDate = newStart;
                        lineChart.endDate = Utils.getEndOfWeek( lineChart.startDate );
                        lineChart.gridSize = 0;
                        break;
                    }
                    lineChart.forceRepaint();
                }
            }
            Row {
                id: periodButtons
                anchors.top: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 4
                spacing: 8
                //
                //
                //
                AfterTrauma.Button {
                    id: yearButton
                    text: "Year"
                    backgroundColour: "transparent"
                    enabled: lineChart.period !== "year"
                    textColour: Colours.darkSlate
                    onClicked: {
                        lineChart.period = "year";
                        lineChart.setup();
                    }
                }
                AfterTrauma.Button {
                    id: monthButton
                    text: "Month"
                    backgroundColour: "transparent"
                    enabled: lineChart.period !== "month"
                    textColour: Colours.darkSlate
                    onClicked: {
                        lineChart.period = "month";
                        lineChart.setup();
                    }
                }
                AfterTrauma.Button {
                    id: weekButton
                    text: "Week"
                    backgroundColour: "transparent"
                    enabled: lineChart.period !== "week"
                    textColour: Colours.darkSlate
                    onClicked: {
                        lineChart.period = "week";
                        lineChart.setup();
                    }
                }
            }
            //
            //
            //
            AfterTrauma.Button {
                id: nextButton
                anchors.top: parent.verticalCenter
                anchors.topMargin: 4
                anchors.right: parent.right
                image: "icons/right_arrow.png"
                backgroundColour: Colours.veryLightSlate
                radius: [0]
                direction: "Left"
                enabled: dailyModel.indexOfFirstDayAfter(lineChart.endDate) > 0;
                onClicked: {
                    var year    = lineChart.startDate.getFullYear();
                    var month   = lineChart.startDate.getMonth();
                    var day     = lineChart.startDate.getDate();
                    switch(lineChart.period) {
                    case "year" :
                        year++;
                        lineChart.startDate = new Date( year,0,1);
                        lineChart.endDate = new Date( year,11,31);
                        lineChart.gridSize = 12;
                        break;
                    case "month" :
                        month++;
                        if ( month > 11 ) {
                            month = 0;
                            year++;
                        }
                        lineChart.startDate = new Date( year, month, 1 );
                        lineChart.endDate = new Date( year, month,Utils.getLastDate(lineChart.startDate));
                        lineChart.gridSize = 0;
                        break;
                    case "week" :
                        var newStart = lineChart.startDate;
                        newStart.setDate(day+7)
                        lineChart.startDate = newStart;
                        lineChart.endDate = Utils.getEndOfWeek( lineChart.startDate );
                        lineChart.gridSize = 0;
                        break;
                    }
                    lineChart.forceRepaint();
                }
            }
            //
            //
            //
            Flow {
                id: legendList
                anchors.top: periodButtons.bottom
                anchors.left: parent.left
                anchors.bottom: parent.bottom
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
                        id: legendItem
                        height: 32
                        width: swatch.width + label.contentWidth + 12
                        opacity: lineChart.datasetActive[lineChart.legend[index].label] ? 1. : .5
                        Rectangle {
                            id: swatch
                            height: 2
                            width: 24
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
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
                            font.pointSize: 18
                            color: lineChart.legend[index].colour
                            text: lineChart.legend[index].label
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log( 'toggling : ' + lineChart.legend[index].label );
                                lineChart.toggleDataSet( lineChart.legend[index].label );
                                //legendItem.opacity = lineChart.active[lineChart.legend[index].label] ? 1. : .5
                            }
                        }
                    }
                }
            }
        }
    }
    footer: Item {
        height: 64
        AfterTrauma.Button {
            text: "share"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            //backgroundColour: Colours.veryLightSlate
            textColour: Colours.almostWhite
            //
            //
            //
            LineChartData {
                id: data
                font: fonts.light;
                title: lineChart.period.charAt(0).toUpperCase() + lineChart.period.slice(1) + 'ly Progess';
                subtitle: lineChart.startDate.toDateString() + ' to ' + lineChart.endDate.toDateString();
                showLegend: true
            }
            //
            //
            //
            onClicked: {
                var pdfPath = SystemUtils.documentDirectory() + '/' + lineChart.period + 'ly.pdf';
                console.log( 'pdf mimetype : ' + SystemUtils.mimeTypeForFile('ly.pdf') );
                data.clearDataSets();
                var categoryIndex = 0;
                for ( var category in lineChart.values ) {
                    data.addDataSet(category,Colours.categoryColour(categoryIndex),lineChart.values[ category ]);
                    categoryIndex++;
                }

                data.clearAxis();
                var xAxis = data.addAxis('days',LineChartData.XAxis,LineChartData.AlignEnd);
                data.setAxisSteps(xAxis, lineChart.period === "year" ? 12 : lineChart.period === "month" ? 4 : 7);
                data.setAxisRange( xAxis, lineChart.startDate, lineChart.endDate);
                var yAxis = data.addAxis('value',LineChartData.YAxis,LineChartData.AlignStart);
                data.setAxisSteps( yAxis, 5 );
                data.save( pdfPath );
                ShareDialog.shareFile('Shared from AfterTrauma', pdfPath);
                //confirmDialog.show('char saved to : ' + pdfPath );
            }
        }
    }
    //
    //
    //
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
