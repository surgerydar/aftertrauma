import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    colour: "transparent"
    //
    //
    //
    Item {
        id: content
        anchors.top: parent.verticalCenter
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //
        //
        //
        DateSlider {
            id: dateSlider
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            onDateChanged: {
                if ( flowerChart ) {
                    flowerChart.setCurrentDate(currentDate.getTime());
                }
            }
        }
        //
        //
        //
        SwipeView {
            id: notifications
            anchors.top: dateSlider.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            //
            //
            //
            Repeater {
                //
                //
                //
                model: notificationModel.count
                //
                //
                //
                delegate:             Page {
                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }
                    Text {
                        anchors.fill: parent
                        color: Colours.almostWhite
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: notificationModel.get( index ).text
                    }
                }
            }
        }
        //
        //
        //
        AfterTrauma.PageIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            currentIndex: notifications.currentIndex
            count: notifications.count
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
        target: flowerChart
        onDateRangeChanged: {
            dateSlider.startDate = startDate
            dateSlider.endDate = endDate
        }
    }
}
