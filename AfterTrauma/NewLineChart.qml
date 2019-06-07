import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Rectangle {
    id: chart
    color: Colours.almostWhite
    property var startDate: new Date()
    property var endDate: new Date()
    property string period: "year"
    property var settings
    property int gridSize: 4
    property real gridStep: gridSize ? (width - canvas.tickMargin) / gridSize : canvas.xGridStep
    property var legend: []
    property var datasetActive: ({})
    property var values: ({})
    //
    //
    //
    Column {
        id: yScale
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: fromDate.top
        anchors.margins: 4
        width: 32
        Repeater {
            model: 4
            Image {
                width: yScale.width
                height: yScale.height / 4
                fillMode: Image.PreserveAspectFit
                opacity: .75
                source: "icons/face" + ( 3 - index ) + ".png"
            }
        }
    }
    //
    //
    //
    Canvas {
        id: canvas
        anchors.top: parent.top
        //anchors.left: parent.left
        anchors.left: yScale.right
        anchors.bottom: fromDate.top
        anchors.right: parent.right
        //
        //
        //
        property int pixelSkip: 1
        property int numDays: 1
        property int tickMargin: 0

        property real xGridStep: (width - tickMargin) / numDays
        property real yGridOffset: height / 26
        property real yGridStep: height / 12

        function drawBackground(ctx) {
            ctx.clearRect(0,0,canvas.width, canvas.height);
        }
        //
        //
        //
        /*
        function drawScales(ctx, high, low, vol) {
            ctx.save();
            ctx.strokeStyle = "#888888";
            ctx.font = "10px Open Sans"
            ctx.beginPath();
            //
            // value on y-axis
            //
            var x = canvas.width - tickMargin + 3;
            var valueStep = (high - low) / 9.0;
            for (var i = 0; i < 10; i += 2) {
                var value = parseFloat(high - i * valueStep).toFixed(1);
                ctx.text(value, x, canvas.yGridOffset + i * yGridStep - 2);
            }
            //
            // date scale
            //
            for (i = 0; i < 3; i++) {
                var volume = volumeToString(vol - (i * (vol/3)));
                ctx.text(volume, x, canvas.yGridOffset + (i + 9) * yGridStep + 10);
            }

            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }
        */
        //
        //
        //
        function drawValues(ctx, points, colour) {
            ctx.save();
            ctx.globalAlpha = 0.7;
            ctx.strokeStyle = colour;
            ctx.lineWidth = 3;
            ctx.beginPath();
            var count = points.length;
            for (var i = 0; i < count; i++) {
                if (i == 0) {
                    ctx.moveTo(points[i].x, points[i].y);
                } else {
                    ctx.lineTo(points[i].x, points[i].y);
                }
            }
            ctx.stroke();
            ctx.restore();
        }
        /*
        function drawError(ctx, msg) {
            ctx.save();
            ctx.strokeStyle = "#888888";
            ctx.font = "24px Open Sans"
            ctx.textAlign = "center"
            ctx.shadowOffsetX = 4;
            ctx.shadowOffsetY = 4;
            ctx.shadowBlur = 1.5;
            ctx.shadowColor = "#aaaaaa";
            ctx.beginPath();

            ctx.fillText(msg, (canvas.width - tickMargin) / 2, (canvas.height - yGridOffset - yGridStep) / 2);

            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }
        */
        //
        //
        //
        onPaint: {
            //
            //
            //
            numDays = Utils.daysBetweenDates(chart.startDate,chart.endDate);

            if (chart.gridSize == 0)
                chart.gridSize = Math.max(1,numDays);

            var startIndex = dailyModel.indexOfFirstDayBefore( chart.startDate );
            var endIndex = dailyModel.indexOfFirstDayAfter( chart.endDate );
            //console.log( 'start: ' + startIndex + ' end: ' + endIndex + ' numDays: ' + numDays );

            var ctx = canvas.getContext("2d");
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 1;

            drawBackground(ctx);

            values = {};
            var points = {};
            var x = 0;
            var previousX = 0;
            //var h = 9 * yGridStep;
            var h = height;
            var minTime = chart.startDate.getTime();
            var maxTime = chart.endDate.getTime();
            var dTime = maxTime - minTime;
            var dIndex = 1;// TODO: skip
            var day, point, value;
            var relativeValue = 0.0;
            if ( startIndex === endIndex ) {
                day = dailyModel.get(startIndex);
                for ( var j = 0; j < day.values.length; j++ ) {
                    value = day.values[j];
                    if ( points[value.label] === undefined ) {
                        points[value.label] = [];
                    }
                    relativeValue = Math.max( 0.0, Utils.map(value.value, 0.25, 1.0, 0.125, 0.875 ) );
                    points[value.label].push({ x: 0, y: h - ( h * relativeValue) });
                    points[value.label].push({ x: width, y: h - ( h * relativeValue ) });
                    //
                    //
                    //
                    if ( values[value.label] === undefined ) {
                        values[value.label] = [];
                    }
                    values[value.label].push( Qt.point(0.,value.value) );
                    values[value.label].push( Qt.point(1.,value.value) );
                }
            } else {
                for (var i = startIndex; i >= endIndex; i -= dIndex ) {
                    //
                    // get daily
                    //
                    day = dailyModel.get(i);
                    //
                    // increment x by diference between samples
                    //
                    x = Utils.daysBetweenMs(chart.startDate.getTime(),day.date) * xGridStep;
                    if ( x == 0 || Math.abs( x - previousX ) >= 1 ) {
                        previousX = x;
                        //
                        // calculate points for each value
                        //
                        var t = ( day.date - minTime ) / dTime;
                        for ( var j = 0; j < day.values.length; j++ ) {
                            value = day.values[j];
                            if ( points[value.label] === undefined ) {
                                points[value.label] = [];
                            }
                            relativeValue = Math.max( 0.0, Utils.map(value.value, 0.25, 1.0, 0.125, 0.875 ) );
                            point = {
                                x: x,
                                y: h - ( h * relativeValue )
                            };
                            points[value.label].push(point);

                            //
                            //
                            //
                            if ( values[value.label] === undefined ) {
                                values[value.label] = [];
                            }
                            values[value.label].push( Qt.point(t,value.value) );
                        }
                    }
                }
            }
            //
            //
            //
            var legend = [];
            i = 0;
            for ( var label in points ) {
                //console.log( 'drawing : ' + name + ' : ' + points[ name ].length + ' points');
                var colour = Colours.categoryColour(i++);
                if ( datasetActive[label] === undefined ) {
                    datasetActive[label] = true;
                }
                if ( datasetActive[ label ] ) {
                    drawValues( ctx, points[ label ], colour);
                }
                legend.push( { label: label, colour: colour } );
            }
            chart.legend = legend;
        }
    }
    //
    //
    //
    PinchArea {
        id: pinchArea
        anchors.fill: parent
        pinch.dragAxis: Pinch.XAxis
        pinch.minimumX: -1.
        pinch.maximumX: 1.
        //pinch.minimumScale: .5
        //pinch.maximumScale: 2.
        onPinchStarted: {
            dateRange = dailyModel.dateRange();
            startX = pinch.center.x;
            startMs = startDate.getTime();
            startPeriod = endDate.getTime() - startMs;
            msPerPixel = startPeriod / width;
        }

        onPinchUpdated: {
            var newPeriod = Math.max( week, Math.min( year, startPeriod * ( 1. / pinch.scale ) ));
            var dPeriod = newPeriod - startPeriod;
            var dX = pinch.center.x - startX;
            var newStartTime = ( ( startMs - ( dX * msPerPixel ) ) - ( dPeriod / 2 ) );
            //newStartTime = Math.max( dateRange.min, Math.min( dateRange.max, newStartTime) );
            newStartTime = Math.max( dateRange.min, Math.min( dateRange.max - newPeriod / 2, newStartTime ) );
            startDate.setTime( newStartTime );
            if ( startDate < globalMinimumDate ) startDate = globalMinimumDate;
            endDate.setTime( startDate.getTime() + newPeriod );
            if ( endDate > globalMaximumDate ) endDate = globalMaximumDate;
            fromDate.text = '< ' + startDate.toDateString();
            toDate.text = endDate.toDateString() + ' >';
            canvas.requestPaint();
        }
        //
        //
        //
        MouseArea {
            anchors.fill: parent
            scrollGestureEnabled: false
            onPressed: {
                pinchArea.dateRange = dailyModel.dateRange();
                pinchArea.startX = mouseX;
                pinchArea.startMs = startDate.getTime();
                pinchArea.startPeriod = endDate.getTime() - pinchArea.startMs;
                pinchArea.msPerPixel = pinchArea.startPeriod / width;
            }
            onMouseXChanged: {
                var dX = mouseX - pinchArea.startX;
                var newStartTime = pinchArea.startMs - ( dX * pinchArea.msPerPixel );
                newStartTime = Math.max( pinchArea.dateRange.min, Math.min( pinchArea.dateRange.max - pinchArea.startPeriod / 2, newStartTime ) );
                startDate.setTime( newStartTime );
                if ( startDate < globalMinimumDate ) startDate = globalMinimumDate;
                endDate.setTime( startDate.getTime() + pinchArea.startPeriod );
                if ( endDate > globalMaximumDate ) {
                    endDate = globalMaximumDate;
                    startDate.setTime( endDate.getTime() - pinchArea.startPeriod );
                }
                fromDate.text = '< ' + startDate.toDateString();
                toDate.text = endDate.toDateString() + ' >';
                canvas.requestPaint();
            }
        }
        //
        //
        //
        property var dateRange: { "min": 0, "max": 0 }
        property real startPeriod: 0
        property real startMs: 0
        property real msPerPixel: 0
        property real startX: 0
        property real week: 1000 * 60 * 60 * 24 * 7
        property real year: 1000 * 60 * 60 * 24 * 7 * 52

    }
    //
    //
    //
    Label {
        id: fromDate
        anchors.left: yScale.right
        anchors.bottom: parent.bottom
        anchors.right: parent.horizontalCenter
        //anchors.rightMargin: ( yScale.x + yScale.width + 8 )
        color: Colours.veryDarkSlate
        fontSizeMode: Label.HorizontalFit
        horizontalAlignment: Label.AlignLeft
        verticalAlignment: Label.AlignBottom
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 32
        text: "< " + startDate.toDateString()
        //
        //
        //
        MouseArea {
            anchors.fill: parent
            onClicked: {
                dateRangePicker.show( function( from, to ) {
                    startDate = from;
                    endDate = to;
                    canvas.requestPaint();
                }, "Progress Dates", startDate, endDate );
            }
        }
    }

    Label {
        id: toDate
        width: fromDate.width
        anchors.right: parent.right
        anchors.rightMargin: canvas.tickMargin
        anchors.bottom: parent.bottom
        color: Colours.veryDarkSlate
        fontSizeMode: Label.HorizontalFit
        horizontalAlignment: Label.AlignRight
        verticalAlignment: Label.AlignBottom
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 32
        text: endDate.toDateString() + " >"
        //
        //
        //
        MouseArea {
            anchors.fill: parent
            onClicked: {
                dateRangePicker.show( function( from, to ) {
                    startDate = from;
                    endDate = to;
                    canvas.requestPaint();
                }, "Progress Dates", startDate, endDate );
            }
        }
    }
    //
    //
    //
    onStartDateChanged: {
        var index = dailyModel.indexOfFirstDayBefore(startDate);
        fromDate.text = '< ' + startDate.toDateString();
    }
    onEndDateChanged: {
        var index = dailyModel.indexOfFirstDayAfter(endDate);
        toDate.text = endDate.toDateString() + ' >';
    }
    /*
    Component.onCompleted: {
        setup();
    }
    */
    //
    //
    //
    function setup() {
        var today = new Date();
        switch( period ) {
        case "year" :
            startDate = new Date( today.getFullYear(),0,1);
            endDate = new Date( today.getFullYear(),11,31);
            break;
        case "month" :
            startDate = new Date( today.getFullYear(),today.getMonth(),1);
            endDate = new Date( today.getFullYear(),today.getMonth(),Utils.getLastDate(today));
            break;
        case "week" :
            startDate = Utils.getStartOfWeek( today );
            endDate = Utils.getEndOfWeek( today );
            break;

        }
        //
        // adjust to fit
        //
        var dateRange = dailyModel.dateRange();
        var newPeriod = endDate.getTime() - startDate.getTime();
        startDate.setTime(Math.max( dateRange.min, Math.min( dateRange.max - newPeriod / 2, startDate.getTime() ) ));
        //
        // clamp date
        // TODO: allow for selected period
        //
        if ( startDate < globalMinimumDate ) endDate = globalMinimumDate;
        if ( endDate > globalMaximumDate ) endDate = globalMaximumDate;
        //
        //
        //
        canvas.requestPaint();
    }
    function forceRepaint() {
        canvas.requestPaint();
    }
    function toggleDataSet( label ) {
        if ( datasetActive[ label ] !== undefined ) {
            datasetActive[ label ]  = !datasetActive[ label ];
        } else {
            console.log( JSON.stringify(datasetActive) );
        }

        console.log( 'LineChart datasetActive[' + label + '] = ' + datasetActive[ label ] );
        canvas.requestPaint();
    }
}
