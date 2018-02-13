import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Rectangle {
    id: chart
    width: 320
    height: 200

    property var startDate: new Date()
    property var endDate: new Date()
    property string period: "year"
    property var settings
    property int gridSize: 4
    property real gridStep: gridSize ? (width - canvas.tickMargin) / gridSize : canvas.xGridStep
    property var legend: []

    property var values: ({})

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
        console.log( 'LineChart.setup : ' + period + ' : start : ' + chart.startDate.toDateString() + ' : end : ' + chart.endDate.toDateString() );
        canvas.requestPaint();
    }

    Row {
        id: periodRow
        anchors.left: chart.left
        anchors.right: chart.right
        anchors.top: chart.top
        anchors.topMargin: 4
        spacing: 8
        /*
        onWidthChanged: {
            var buttonsLen = previousButton.width + nextButton.width + yearButton.width + monthButton.width + weekButton.width;
            var space = (width - buttonsLen) / 3;
            spacing = Math.max(space, 10);
        }
        */
        AfterTrauma.Button {
            id: previousButton
            image: "icons/left_arrow.png"
            backgroundColour: Colours.red
            radius: [0]
            direction: "Right"
            onClicked: {
                var year    = chart.startDate.getFullYear();
                var month   = chart.startDate.getMonth();
                var day     = chart.startDate.getDate();
                switch(chart.period) {
                case "year" :
                    year--;
                    startDate = new Date( year,0,1);
                    endDate = new Date( year,11,31);
                    chart.gridSize = 12;
                    break;
                case "month" :
                    month--;
                    if ( month < 0) {
                        month = 11;
                        year--;
                    }
                    startDate = new Date( year, month, 1 );
                    endDate = new Date( year, month,Utils.getLastDate(startDate));
                    gridSize = 0;
                    break;
                case "week" :
                    var newStart = chart.startDate;
                    newStart.setDate(day-7)
                    chart.startDate = newStart;
                    chart.endDate = Utils.getEndOfWeek( startDate );
                    gridSize = 0;
                    break;
                }
                canvas.requestPaint();
            }
        }
        AfterTrauma.Button {
            id: nextButton
            image: "icons/right_arrow.png"
            backgroundColour: Colours.red
            radius: [0]
            direction: "Left"
            onClicked: {
                var year    = chart.startDate.getFullYear();
                var month   = chart.startDate.getMonth();
                var day     = chart.startDate.getDate();
                switch(chart.period) {
                case "year" :
                    year++;
                    startDate = new Date( year,0,1);
                    endDate = new Date( year,11,31);
                    chart.gridSize = 12;
                    break;
                case "month" :
                    month++;
                    if ( month > 11 ) {
                        month = 0;
                        year++;
                    }
                    startDate = new Date( year, month, 1 );
                    endDate = new Date( year, month,Utils.getLastDate(startDate));
                    gridSize = 0;
                    break;
                case "week" :
                    var newStart = chart.startDate;
                    newStart.setDate(day+7)
                    chart.startDate = newStart;
                    chart.endDate = Utils.getEndOfWeek( startDate );
                    gridSize = 0;
                    break;
                }
                canvas.requestPaint();
            }
        }
        AfterTrauma.Button {
            id: yearButton
            text: "Year"
            backgroundColour: "transparent"
            enabled: chart.period !== "year"
            textColour: Colours.darkSlate
            onClicked: {
                chart.period = "year";
                chart.setup();
            }
        }
        AfterTrauma.Button {
            id: monthButton
            text: "Month"
            backgroundColour: "transparent"
            enabled: chart.period !== "month"
            textColour: Colours.darkSlate
            onClicked: {
                chart.period = "month";
                chart.setup();
            }
        }
        AfterTrauma.Button {
            id: weekButton
            text: "Week"
            backgroundColour: "transparent"
            enabled: chart.period !== "week"
            textColour: Colours.darkSlate
            onClicked: {
                chart.period = "week";
                chart.setup();
            }
        }
        //
        //
        //

        AfterTrauma.Button {
            text: "Share"
            backgroundColour: Colours.veryLightSlate
            textColour: Colours.almostWhite
            LineChartData {
                id: data
                font: fonts.light;
                title: chart.period.charAt(0).toUpperCase() + chart.period.slice(1) + 'ly Progess';
                subtitle: startDate.toDateString() + ' to ' + endDate.toDateString();
                showLegend: true
            }

            onClicked: {
                var pdfPath = SystemUtils.documentDirectory() + '/' + chart.period + 'ly.pdf';

                data.clearDataSets();
                var categoryIndex = 0;
                for ( var category in values ) {
                    data.addDataSet(category,Colours.categoryColour(categoryIndex),values[ category ]);
                    categoryIndex++;
                }

                data.clearAxis();
                var xAxis = data.addAxis('days',LineChartData.XAxis,LineChartData.AlignEnd);
                data.setAxisSteps(xAxis, chart.period === "year" ? 12 : chart.period === "month" ? 4 : 7);
                data.setAxisRange( xAxis, startDate, endDate);
                var yAxis = data.addAxis('value',LineChartData.YAxis,LineChartData.AlignStart);
                data.setAxisSteps( yAxis, 5 );
                data.save( pdfPath );
                ShareDialog.shareFile('Shared from AfterTrauma', pdfPath);
                //confirmDialog.show('char saved to : ' + pdfPath );
            }
        }
    }

    Text {
        id: fromDate
        color: Colours.veryDarkSlate
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 8
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: "| " + startDate.toDateString()
    }

    Text {
        id: toDate
        color: Colours.veryDarkSlate
        font.weight: Font.Light
        font.family: fonts.light
        font.pointSize: 8
        anchors.right: parent.right
        anchors.rightMargin: canvas.tickMargin
        anchors.bottom: parent.bottom
        text: endDate.toDateString() + " |"
    }

    Canvas {
        id: canvas

        // Uncomment below lines to use OpenGL hardware accelerated rendering.
        // See Canvas documentation for available options.
        // renderTarget: Canvas.FramebufferObject
        // renderStrategy: Canvas.Threaded

        anchors.top: periodRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: fromDate.top

        property int pixelSkip: 1
        property int numDays: 1
        property int tickMargin: 34

        property real xGridStep: (width - tickMargin) / numDays
        property real yGridOffset: height / 26
        property real yGridStep: height / 12

        function drawBackground(ctx) {
            ctx.save();
            ctx.fillStyle = Colours.almostWhite;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.strokeStyle = Colours.veryLightSlate;
            ctx.beginPath();
            // Horizontal grid lines
            for (var i = 0; i < 12; i++) {
                ctx.moveTo(0, canvas.yGridOffset + i * canvas.yGridStep);
                ctx.lineTo(canvas.width, canvas.yGridOffset + i * canvas.yGridStep);
            }

            // Vertical grid lines
            var height = 35 * canvas.height / 36;
            var yOffset = canvas.height - height;
            var xOffset = 0;
            for (i = 0; i < chart.gridSize; i++) {
                ctx.moveTo(xOffset + i * chart.gridStep, yOffset);
                ctx.lineTo(xOffset + i * chart.gridStep, height);
            }
            ctx.stroke();

            // Right ticks
            ctx.strokeStyle = Colours.veryLightSlate;
            ctx.beginPath();
            var xStart = canvas.width - tickMargin;
            ctx.moveTo(xStart, 0);
            ctx.lineTo(xStart, canvas.height);
            for (i = 0; i < 12; i++) {
                ctx.moveTo(xStart, canvas.yGridOffset + i * canvas.yGridStep);
                ctx.lineTo(canvas.width, canvas.yGridOffset + i * canvas.yGridStep);
            }
            ctx.moveTo(0, canvas.yGridOffset + 9 * canvas.yGridStep);
            ctx.lineTo(canvas.width, canvas.yGridOffset + 9 * canvas.yGridStep);
            ctx.closePath();
            ctx.stroke();

            ctx.restore();
        }

        function drawScales(ctx, high, low, vol)
        {
            ctx.save();
            ctx.strokeStyle = "#888888";
            ctx.font = "10px Open Sans"
            ctx.beginPath();

            // prices on y-axis
            var x = canvas.width - tickMargin + 3;
            var priceStep = (high - low) / 9.0;
            for (var i = 0; i < 10; i += 2) {
                var price = parseFloat(high - i * priceStep).toFixed(1);
                ctx.text(price, x, canvas.yGridOffset + i * yGridStep - 2);
            }

            // volume scale
            for (i = 0; i < 3; i++) {
                var volume = volumeToString(vol - (i * (vol/3)));
                ctx.text(volume, x, canvas.yGridOffset + (i + 9) * yGridStep + 10);
            }

            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }

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

            ctx.fillText(msg, (canvas.width - tickMargin) / 2,
                              (canvas.height - yGridOffset - yGridStep) / 2);

            ctx.closePath();
            ctx.stroke();
            ctx.restore();
        }

        onPaint: {
            //
            //
            //
            numDays = Utils.daysBetweenDates(chart.startDate,chart.endDate);
            if ( numDays === 0 ) return;
            if (chart.gridSize == 0)
                chart.gridSize = numDays

            var startIndex = dailyModel.indexOfFirstDayBefore( chart.startDate );
            var endIndex = dailyModel.indexOfFirstDayAfter( chart.endDate );
            console.log( 'start: ' + startIndex + ' end: ' + endIndex + ' numDays: ' + numDays );

            var ctx = canvas.getContext("2d");
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 1;

            drawBackground(ctx);

            values = {};
            var points = {};
            var x = 0;
            var h = 9 * yGridStep;
            var minTime = chart.startDate.getTime();
            var maxTime = chart.endDate.getTime();
            var dTime = maxTime - minTime;
            for (var i = startIndex; i >= endIndex; i-- ) {
                //
                // get daily
                //
                var day = dailyModel.get(i);
                //
                // increment x by diference between samples
                //
                x = Utils.daysBetweenMs(chart.startDate.getTime(),day.date) * xGridStep;
                //
                // calculate points for each value
                //
                var t = ( day.date - minTime ) / dTime;
                for ( var j = 0; j < day.values.length; j++ ) {
                    var value = day.values[j];
                    if ( points[value.label] === undefined ) {
                        points[value.label] = [];
                    }
                    var point = {
                        x: x,
                        y: h - ( h * value.value )
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
            //
            //
            //
            var legend = [];
            i = 0;
            for ( var label in points ) {
                //console.log( 'drawing : ' + name + ' : ' + points[ name ].length + ' points');
                var colour = Colours.categoryColour(i++);
                drawValues( ctx, points[ label ], colour);
                legend.push( { label: label, colour: colour } );
            }
            chart.legend = legend;
            //
            //
            //
            //drawScales(ctx, highestPrice, lowestPrice, highestVolume);
        }
    }
    //
    //
    //
    onStartDateChanged: {
        var index = dailyModel.indexOfFirstDayBefore(startDate);
        previousButton.enabled = index < dailyModel.count - 1;
        fromDate.text = '| ' + startDate.toDateString();
    }
    onEndDateChanged: {
        var index = dailyModel.indexOfFirstDayAfter(endDate);
        nextButton.enabled = index > 0;
        toDate.text = endDate.toDateString() + ' |';
    }

    /*
    Component.onCompleted: {
        setup();
    }
    */
}
