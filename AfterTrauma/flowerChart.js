.import "colours.js" as Colours
//
//
//
var data = null;
var labels = null;
var currentData = null;
var previousData = null;
var nextData = null;
var startDate = 0;
var endDate = 0;
var minValue = 0;
var maxValue = 0;
var pallet = [ Colours.darkPurple, Colours.blue, Colours.darkOrange, Colours.lightPurple, Colours.darkGreen ];
var frameAnimation = null;
var interpolation = 0.;
//
// dataSet = { labels: [ label1, label2, ... ], data: [ [ time, [ value1, value2, ... ] ], [ time, [ value1, value2, ... ] ], ... ] }
//
function useTestData() {
    var testDataSet = {
        labels: [ 'MIND', 'BODY', 'LIFE', 'RELATIONSHIPS', 'EMOTIONS'],
        data: []
    }

    var nWeeks = 8;
    var week = 60 * 60 * 24 * 7 * 1000;
    var time = Date.now() - (nWeeks * week) ;
    for ( var i = 0; i < nWeeks; i++ ) {
        var dataPoint = [time,[ Math.random(),Math.random(), Math.random(),Math.random(),Math.random()]];
        testDataSet.data.push(dataPoint);
        time += week;
    }
    console.log( 'using test data' );
    console.log( JSON.stringify(testDataSet) );
    setData(testDataSet);
}

function setData( dataSet ) {
    //
    //
    //
    data = dataSet.data;
    labels = dataSet.labels;
    //
    // update date range and min / max values
    //
    startDate = Date.now();
    endDate = 0;
    minValue = 1.;
    maxValue = .0;
    data.forEach( function( entry ) {
        console.log( 'datapoint date : ' + entry[ 0 ] );
        if ( entry[ 0 ] < startDate ) startDate = entry[ 0 ];
        if ( entry[ 0 ] > endDate ) endDate = entry[ 0 ];
        var count = entry[ 1 ].length;
        for ( var i = 0; i < count; i++ ) {
            if ( entry[ 1 ][ i ] < minValue ) minValue = entry[ 1 ][ i ];
            if ( entry[ 1 ][ i ] > maxValue ) maxValue = entry[ 1 ][ i ];
        }
    });

    //
    //
    //
    currentData = [];
    previousData = [];
    for ( var i = 0; i <  5; i++ ) {
        currentData.push(0.);
        previousData.push(0.);
    }

    setCurrentDate(startDate);
}

function setCurrentDate( date ) {
    if( data && data.length > 0 ) {
        var count = data.length - 1;
        for ( var i = 0; i < count; i++ ) {
            if ( data[ i ][ 0 ] <= date && data[ i + 1 ][ 0 ] > date ) {
                // interpolate between i and i + 1
                var interp = ( date - data[ i ][ 0 ] ) / ( data[ i + 1 ][ 0 ] - data[ i ][ 0 ] );
                if ( interp <= 0 ) {
                    nextData = data[ i ][ 1 ].slice();
                } else if ( interp >= 1 ) {
                    nextData = data[ i + 1 ][ 1 ].slice();
                } else {
                    nextData = [];
                    for ( var j = 0; j < data[ i ][ 1 ].length; j++ ) {
                        nextData.push( data[ i ][ 1 ][ j ] + ((data[ i + 1 ][ 1 ][ j ]-data[ i ][ 1 ][ j ])*interp));
                    }
                }
                //console.log( 'setCurrentDate : nextData : ' + nextData.join() );
                return;
            }
        }
        //
        // fallen off the end of time so use last entry
        //
        nextData = data[ count ][ 1 ].slice();
    }
}

function startAnimation() {
    interpolation = 0.;
}

function update( factor ) {
    if( currentData && nextData && interpolation < 1. ) {
        for ( var i = 0; i < currentData.length; i++ ) {
            currentData[ i ] = currentData[ i ] + ( nextData[ i ] - currentData[ i ] ) * interpolation;
            //console.log( 'update : ' + currentData[ i ] );
        }

        interpolation += 0.01;
    }
    return interpolation <= 1.;
}

function draw( ctx ) {
    if( currentData ) {
        var sweep = (2*Math.PI) / 5.;
        var angle  = 0.;
        var width = ctx.canvas.width;
        var height = ctx.canvas.height;
        var radius = Math.min(width,height) / 2.;
        var cp = Qt.point(width/2.,height/2.);
        //
        //
        //
        ctx.clearRect(0,0,width,height);
        //
        // draw background
        //
        var gradient = ctx.createRadialGradient(cp.x, cp.y, 0, cp.x, cp.y, radius);
        gradient.addColorStop(0.,Qt.rgba(1.,1.,1.,.5));
        gradient.addColorStop(1.,Qt.rgba(1.,1.,1.,.15));
        ctx.fillStyle = gradient;
        ctx.beginPath();
        ctx.arc(cp.x,cp.y,radius,0.,2.*Math.PI);
        ctx.fill();
        //
        // draw values
        //
        for ( var i = 0; i < 5; i++ ) {
            var value = currentData[ i ] * radius;
            drawFlower(ctx, cp, value, angle, sweep, pallet[ i ]);
            angle += sweep;
        }
        //
        // draw min / max
        //
        ctx.strokeStyle = Qt.rgba(1.,1.,1.,1.);
        ctx.lineWidth = 2;
        //ctx.setLineDash([4,4]);
        ctx.beginPath();
        ctx.arc(cp.x,cp.y,radius* maxValue,0.,2.*Math.PI);
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(cp.x,cp.y,radius* minValue,0.,2.*Math.PI);
        ctx.stroke();
    }
}

function drawFlower( ctx, cp, radius, angle, sweep, colour ) {
    var p1 = Qt.point(
                cp.x+(Math.cos(angle)*radius-Math.sin(angle)),
                cp.y+(Math.sin(angle)*radius-Math.cos(angle))
                );
    var p3 = Qt.point(
                cp.x+(Math.cos(angle+sweep/2.)*radius-Math.sin(angle+sweep/2.)),
                cp.y+(Math.sin(angle+sweep/2.)*radius-Math.cos(angle+sweep/2.))
                );
    var p5 = Qt.point(
                cp.x+(Math.cos(angle+sweep)*radius-Math.sin(angle+sweep)),
                cp.y+(Math.sin(angle+sweep)*radius-Math.cos(angle+sweep))
                );
    var p0 = Qt.point(
                (cp.x + p1.x)/2.,
                (cp.y + p1.y)/2.
                );
    var p6 = Qt.point(
                (cp.x+p5.x)/2.,
                (cp.y+p5.y)/2.
                );
    var chord = Qt.point(
                p5.x-p1.x,
                p5.y-p1.y
                );
    var chordLength = Math.sqrt(chord.x*chord.x+chord.y*chord.y);
    var chordNorm = Qt.point(
                chord.x/chordLength,
                chord.y/chordLength
                );
    var p2 = Qt.point(
                p3.x-(chord.x/4.),
                p3.y-(chord.y/4.)
                );
    var p4 = Qt.point(
                p3.x+(chord.x/4.),
                p3.y+(chord.y/4.)
                );
    ctx.fillStyle = colour;
    ctx.beginPath();
    ctx.moveTo(cp.x,cp.y);
    ctx.lineTo(p0.x,p0.y);
    ctx.bezierCurveTo(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    ctx.bezierCurveTo(p4.x, p4.y, p5.x, p5.y, p6.x, p6.y);
    ctx.closePath();
    ctx.fill();
}

function setTime( time ) {

}
