import QtQuick 2.7
import QtQuick.Controls 2.1
import "../colours.js" as Colours

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
                text: index
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( currentIndex > -1 ) {
                    updateDate();
                }
            }
        }
    }
    Text {
        id: output
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: currentDate.toDateString()
    }

    Component.onCompleted: {
        console.log('DatePicker.Component.onCompleted() : currentDate=' + currentDate.toDateString() );
        blockUpdate         = true;
        currentDate.setHours(0,0,0,0); // standardise time
        year.model          = 30000;
        year.currentIndex   = currentDate.getFullYear();
        month.model         = 12;
        month.currentIndex  = currentDate.getMonth();
        day.model           = daysInMonth(currentDate.getFullYear(),currentDate.getMonth());
        day.currentIndex    = currentDate.getDate() - 1;
        console.log('DatePicker.Component.onCompleted() : ' + currentDate.getDate() + '/' + currentDate.getMonth() + '/' + currentDate.getFullYear() );
        console.log('DatePicker.Component.onCompleted() : ' + day.currentIndex + '/' + month.currentIndex + '/' + year.currentIndex );
        blockUpdate = false;
    }

    function daysInMonth( _year, _month ) {
        return new Date(_year, _month+1, 0).getDate();
    }

    function updateDate() {
        if ( !blockUpdate ) {
            var maxDays = daysInMonth(year.currentIndex,month.currentIndex);
            console.log( 'updateDate() : maxDays=' + maxDays + ' day.model=' + day.model );
            if ( maxDays != day.model ) {
                var dayIndex        = Math.min(day.currentIndex,maxDays-1);
                day.model           = maxDays;
                day.currentIndex    = dayIndex;
            }
            var date = new Date();
            date.setFullYear(year.currentIndex, month.currentIndex, day.currentIndex+1);
            currentDate = date;
        }
    }

    onCurrentDateChanged: {

    }

    property bool blockUpdate: false
    property date currentDate: new Date()
}
