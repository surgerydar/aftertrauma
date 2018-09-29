import QtQuick 2.7
import QtQuick.Controls 2.1

import SodaControls 1.0

import "../colours.js" as Colours
import "../utils.js" as Utils

Item {
    id: container
    //
    //
    //
    Row {
        spacing: 4
        anchors.fill: parent
        //
        //
        //
        Tumbler {
            id: day
            width: ( parent.width - 8 ) / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.veryDarkSlate
            }
            //
            //
            //
            delegate: Label {
                height: 64
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                color: Colours.almostWhite
                font.family: fonts.light
                font.pointSize: 18
                text: index + 1
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( currentIndex > -1 ) {
                    updateDate();
                }
            }
            //
            //
            //
            function currentValue() {
                return currentIndex;
            }
        }
        Tumbler {
            id: month
            width: ( parent.width - 8 ) / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //
            //
            //
            //model: 12
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.veryDarkSlate
            }
            //
            //
            //
            delegate: Label {
                height: 64
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                color: Colours.almostWhite
                font.family: fonts.light
                font.pointSize: 18
                text: textMonth ? Utils.longMonth(index) : index + 1
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( currentIndex > -1 ) {
                    updateDate();
                }
            }
            //
            //
            //
            function currentValue() {
                return currentIndex;
            }
        }
        Tumbler {
            id: year
            width: ( parent.width - 8 ) / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //
            //
            //
            //model: 3000
            /*model: RangeModel {
                min: 2016
                max: new Date().getFullYear() + 1
            }
            */
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.veryDarkSlate
            }
            //
            //
            //
            delegate: Label {
                height: 64
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                color: Colours.almostWhite
                font.family: fonts.light
                font.pointSize: 18
                //text: value
                text: index >= minimumDate.getFullYear() ? index <= maximumDate.getFullYear() ? index : "" : ""
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( currentIndex > -1 ) {
                    updateDate();
                }
            }
            //
            //
            //
            function currentValue() {
                //return model.get(currentIndex);
                return currentIndex;
            }
        }
    }
    /*
    Text {
        id: output
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: currentDate.toDateString()
    }
    */
    Component.onCompleted: {
        //console.log('DatePicker.Component.onCompleted() : currentDate=' + currentDate.toDateString() );
        updateUI();
    }
    //
    //
    //
    onMinimumDateChanged: {
        if ( currentDate < minimumDate ) {
            currentDate = new Date(minimumDate);
            updateUI();
        }
    }
    onMaximumDateChanged: {
        if ( currentDate > maximumDate ) {
            currentDate = new Date(maximumDate);
            updateUI();
        }
    }
    //
    //
    //
    function daysInMonth( _year, _month ) {
        return new Date(_year, _month+1, 0).getDate();
    }

    function updateDate() {
        if ( !blockUpdate ) {
            var maxDays = daysInMonth(year.currentValue(),month.currentValue());
            //console.log( 'updateDate() : maxDays=' + maxDays + ' day.model=' + day.model );
            if ( maxDays != day.model ) {
                var dayIndex        = Math.min(day.currentValue(),maxDays-1);
                day.model           = maxDays;
                day.currentIndex    = dayIndex;
            }
            var date = new Date();
            date.setFullYear(year.currentValue(), month.currentValue(), day.currentValue()+1);
            if ( date < minimumDate ) {
                currentDate = new Date( minimumDate );
                updateUI();
            } else if ( date > maximumDate ) {
                currentDate = new Date( maximumDate );
                updateUI();
            } else {
                currentDate = date;
            }
        }
    }

    function updateUI() {
        blockUpdate         = true;
        currentDate.setHours(0,0,0,0); // standardise time
        year.model          = 30000;
        //year.currentIndex   = currentDate.getFullYear() - year.model.min;
        year.currentIndex   = currentDate.getFullYear();
        month.model         = 12;
        month.currentIndex  = currentDate.getMonth();
        day.model           = daysInMonth(currentDate.getFullYear(),currentDate.getMonth());
        day.currentIndex    = currentDate.getDate() - 1;
        //
        //
        //
        //console.log( 'DatePicker.updateUI : ' + currentDate );
        //console.log('DatePicker.updateUI : ' + currentDate.getDate() + '/' + currentDate.getMonth() + '/' + currentDate.getFullYear() );
        //console.log('DatePicker.updateUI : ' + day.currentValue() + '/' + month.currentValue() + '/' + year.currentValue() );
        blockUpdate = false;
    }
    //
    //
    //
    property bool blockUpdate: false
    property bool textMonth: false
    property date currentDate: new Date()
    property date minimumDate: globalMinimumDate || new Date()
    property date maximumDate: globalMaximumDate || new Date()
}
