import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    colour: "transparent"
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            var mp = mapToItem(flowerChart,mouseX,mouseY);
            flowerChart.selectCategoryAt( mp.x, mp.y );
        }
    }
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
        /* now handled by system notifications
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
                delegate: Item {
                    Text {
                        anchors.fill: parent
                        color: Colours.almostWhite
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        font.family: fonts.light
                        fontSizeMode: Text.Fit
                        minimumPointSize: 12
                        text: notificationModel.get( index ).text
                    }
                }
            }

        }
        AfterTrauma.PageIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            currentIndex: notifications.currentIndex
            count: notifications.count
            colour: Colours.almostWhite
        }
        */
    }
    //
    //
    //
    /*
    Timer {
        id: scrollTimer
        interval: 30 * 1000
        repeat: true
        onTriggered: {
            if ( notifications.count ) {
                if ( notifications.currentIndex < notifications.count - 1 ) {
                    notifications.currentIndex++;
                } else {
                    notifications.currentIndex = 0;
                }
            }
        }
    }
    */
    //
    //
    //
    StackView.onActivated: {
        //scrollTimer.start();
        dateSlider.value = 1;
        flowerChart.enabled = true;
        flowerChart.values = dailyModel.valuesForDate( dateSlider.currentDate.getTime() );
    }
    StackView.onDeactivated: {
        //scrollTimer.stop();
        flowerChart.enabled = false;
    }
    //
    //
    //
    Connections {
        target: notificationModel
        onUpdated: {
            // now handled by system level notifications
            //console.log( 'Dashboard : notificationModel updated');
            //notificationsRepeater.model = notificationModel.count
        }
    }
}
