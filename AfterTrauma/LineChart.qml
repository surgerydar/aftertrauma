import QtQuick 2.7
import QtQuick.Controls 2.1

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
        console.log( 'LineChart.update : start : ' + chart.startDate.toDateString() + ' : end : ' + chart.endDate.toDateString() );
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
                    chart.startDate.setDate(day-7);
                    chart.endDate.setDate(chart.endDate.getDate()-7);
                    gridSize = 0;
                    break;
                }
                canvas.requestPaint();
            }
        }
        AfterTrauma.Button {
            id: nextButton
            image: "icons/right_arrow.png"
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
                    chart.startDate.setDate(day+7);
                    chart.endDate.setDate(chart.endDate.getDate()+7);
                    gridSize = 0;
                    break;
                }
                canvas.requestPaint();
            }
        }
        AfterTrauma.Button {
            id: yearButton
            text: "Year"
            enabled: chart.period !== "year"
            onClicked: {
                chart.period = "year";
                chart.setup();
            }
        }
        AfterTrauma.Button {
            id: monthButton
            text: "Month"
            enabled: chart.period !== "month"
            onClicked: {
                chart.period = "month";
                chart.setup();
            }
        }
        AfterTrauma.Button {
            id: weekButton
            text: "Week"
            enabled: chart.period !== "week"
            onClicked: {
                chart.period = "week";
                chart.setup();
            }
        }
    }

    Text {
        id: fromDate
        color: Colours.veryDarkSlate
        //font.family: fonts.light.name
        font.pointSize: 8
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: "| " + startDate.toDateString()
    }

    Text {
        id: toDate
        color: Colours.veryDarkSlate
        //font.family: fonts.light.name
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

            var startIndex = dailyModel.indexOf( chart.startDate );
            //if ( startIndex > 0 ) startIndex--;
            var endIndex = dailyModel.indexOf( chart.endDate );
            //if ( endIndex < dailyModel.count - 1 ) endIndex++;

            var ctx = canvas.getContext("2d");
            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 1;

            drawBackground(ctx);

            var points = {};
            var x = 0;
            var previousDay = undefined;
            var h = 9 * yGridStep;
            console.log( 'start: ' + startIndex + ' end: ' + endIndex + ' numDays: ' + numDays );
            for (var i = startIndex; i >= endIndex; i-- ) {
                //
                // get daily
                //
                var day = dailyModel.get(i);
                //
                // increment x by diference between samples
                //
                if ( previousDay !== undefined ) {
                    x += Utils.daysBetweenMs(previousDay.date,day.date) * xGridStep;
                } else {
                    x = Utils.daysBetweenMs(chart.startDate.getTime(),day.date) * xGridStep;
                }
                //
                // calculate points for each value
                //
                previousDay = day;
                for ( var j = 0; j < day.values.count; j++ ) {
                    var value = day.values.get(j);
                    if ( points[value.name] === undefined ) {
                        points[value.name] = [];
                    }
                    var point = {
                        x: x,
                        y: h - ( h * value.value )
                    };
                    console.log( value.name + ' : ' + i + ' : ' + JSON.stringify(point) );
                    points[value.name].push(point);
                }
            }
            //
            //
            //
            var legend = [];
            i = 0;
            for ( var name in points ) {
                //console.log( 'drawing : ' + name + ' : ' + points[ name ].length + ' points');
                var colour = Colours.categoryColour(i++);
                drawValues( ctx, points[ name ], colour);
                legend.push( { name: name, colour: colour } );
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
    Component.onCompleted: {
        setup();
    }
}
