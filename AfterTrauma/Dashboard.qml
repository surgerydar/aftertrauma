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
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.topMargin: flowerChart ? flowerChart.y + ( flowerChart.height - ( dateSlider.height / 2 ) ) : parent.height / 2
        //
        //
        //
        DateSlider {
            id: dateSlider
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            onDateChanged: {
                if ( flowerChart ) {
                    flowerChart.values = dailyModel.valuesForDate( currentDate.getTime() );
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
                id: notificationsRepeater
                //
                //
                //
                model: notificationModel.count
                //
                //
                //
                delegate: Page {
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
            colour: Colours.almostWhite
        }
    }
    //
    //
    //
    Timer {
        id: scrollTimer
        interval: 30 * 1000
        repeat: true
        onTriggered: {
            if ( notifications.count ) {
                if ( notifications.currentIndex < notifications.count - 1 ) {
                    notifications.currentIndex = 0;
                } else {
                    notifications.currentIndex++;
                }
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        scrollTimer.start();
        dateSlider.value = 1;
        //dateSlider.updateDisplay(dateSlider.value);
        flowerChart.enabled = true;
        flowerChart.values = dailyModel.valuesForDate( dateSlider.currentDate.getTime() );
    }
    StackView.onDeactivated: {
        scrollTimer.stop();
        flowerChart.enabled = false;
    }
    //
    //
    //
    Connections {
        target: notificationModel
        onUpdated: {
            notificationsRepeater.model = notificationModel.count
        }
    }
}
