import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

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
            visible: !flowerChartAnimator.running
            showSlider: Utils.daysBetweenDates( globalMinimumDate, globalMaximumDate ) > 1
            onDateChanged: {
                setGlobalDate(currentDate);
            }
        }
        Item {
            height: label.contentHeight + 16
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 4
            visible: flowerChartAnimator.running
            Rectangle {
                anchors.fill: parent
                color: Colours.darkOrange
            }
            AfterTrauma.Label {
                id: label
                anchors.fill: parent
                color: Colours.almostWhite
                wrapMode: Label.WordWrap
                text: "The flower tracker petals grow or shrink to help you track your <a href='link://recovery'>Recovery</a>"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.navigateTo("qrc:///Questionnaire.qml");
                }
            }
        }

    }
    footer: Item {
        height: 0
    }
    //
    //
    //
    //
    //
    StackView.onActivated: {
        //scrollTimer.start();
        dateSlider.showSlider = Utils.daysBetweenDates( globalMinimumDate, globalMaximumDate ) > 1;
        dateSlider.value = 1;
        dateSlider.updateDisplay(1);
        flowerChart.enabled = true;
        setGlobalDate(dateSlider.currentDate);
    }
    StackView.onDeactivated: {
        flowerChart.enabled = false;
    }
}
