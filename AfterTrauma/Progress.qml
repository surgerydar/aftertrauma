import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils
import SodaControls 1.0

AfterTrauma.Page {
    id: container
    title: "MY PROGRESS"
    colour: Colours.almostWhite
    //
    //
    //
    Item {
        id: graph
        anchors.fill: parent
        //
        //
        //
        NewLineChart {
            id: lineChart
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: legendList.top
            anchors.bottomMargin: 4
        }
        //
        //
        //
        Rectangle {
            id: legendList
            height: parent.height / 4
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: Colours.almostWhite
            //
            //
            //
            Flow {
                anchors.fill: parent
                anchors.margins: 16
                //
                //
                //
                //padding: 16
                spacing: 4
                flow: Flow.LeftToRight
                //
                //
                //
                Repeater {
                    model: lineChart.legend
                    //
                    //
                    //
                    AfterTrauma.Button {
                        height: 24
                        backgroundColour: lineChart.legend[index].colour
                        textSize: 18
                        text: lineChart.legend[index].label
                        checkable: true
                        checked: true
                        opacity: checked ? 1. : .5
                        onClicked: {
                            lineChart.toggleDataSet( lineChart.legend[index].label );
                        }
                    }
                    /*
                    Text {
                        id: label
                        padding: 8
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Light
                        font.family: fonts.light
                        font.pointSize: 18
                        color: lineChart.legend[index].colour
                        text: lineChart.legend[index].label
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                lineChart.toggleDataSet( lineChart.legend[index].label );
                            }
                        }
                    }
                    */
                    /*
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
                            }
                        }
                    }
                    */
                }
            }
        }
    }
    //
    //
    //
    footer: Item {
        height: 64
        AfterTrauma.Button {
            text: "share"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            textColour: Colours.almostWhite
            //
            //
            //
            LineChartData {
                id: data
                font: fonts.light;
                title: 'My Progress';
                subtitle: lineChart.startDate.toDateString() + ' to ' + lineChart.endDate.toDateString();
                showLegend: true
            }
            //
            //
            //
            onClicked: {
                /*
                var day = new Date();
                var pdfPath = SystemUtils.documentDirectory() + '/myprogress-' + day.getDate() + '-' + day.getMonth() + '-' + day.getFullYear() + '.pdf';
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
                */
                var day = new Date();
                var pngPath = SystemUtils.documentDirectory() + '/myprogress-' + day.getDate() + '-' + day.getMonth() + '-' + day.getFullYear() + '.png';
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
                data.save( pngPath );
                ShareDialog.shareFile('Shared from AfterTrauma', pngPath);
                //
                //
                //
                usageModel.add('progress', 'share', { fromdate:lineChart.startDate.getTime(),todate: lineChart.endDate.getTime() } );
            }
        }
    }
    //
    //
    //
    property bool onStack: false
    StackView.onActivated: {
        console.log('period: ' + period );
        lineChart.period = container.period;
        lineChart.setup();
        //
        //
        //
        if ( !onStack ) {
            onStack = true;
            usageModel.add('progress', 'open' );
        }
    }
    StackView.onRemoved: {
        onStack = false;
        usageModel.add('progress', 'close' );
    }
    //
    //
    //
    property string period: "year" // year | month | week
}
