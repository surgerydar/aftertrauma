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
                    flowerChart.maxValues = rehabModel.getGoalValues(currentDate.getTime());
                    flowerChart.values = dailyModel.valuesForDate( currentDate.getTime() );
                }
            }
        }
    }
    //
    //
    //
    //
    //
    StackView.onActivated: {
        //scrollTimer.start();
        dateSlider.value = 1;
        flowerChart.enabled = true;
        flowerChart.maxValues = rehabModel.getGoalValues( dateSlider.currentDate.getTime());
        flowerChart.values = dailyModel.valuesForDate( dateSlider.currentDate.getTime() );
    }
    StackView.onDeactivated: {
        flowerChart.enabled = false;
    }
}
