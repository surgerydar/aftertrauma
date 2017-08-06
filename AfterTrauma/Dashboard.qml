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
            Page {
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                Text {
                    anchors.fill: parent
                    color: Colours.almostWhite
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "notification 1"
                }
            }
            Page {
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                Text {
                    anchors.fill: parent
                    color: Colours.almostWhite
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "notification 2"
                }
            }
            Page {
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                Text {
                    anchors.fill: parent
                    color: Colours.almostWhite
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "notification 3"
                }
            }
            Page {
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }

                Text {
                    anchors.fill: parent
                    color: Colours.almostWhite
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "notification 4"
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
}
