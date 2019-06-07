import QtQuick 2.6

Canvas {

    onPaint : {
        var ctx = getContext("2d");
        if ( fill ) {
            ctx.fillStyle = fill;
        }
        if ( lineWidth > 0 ) {
            if ( stroke ) {
                ctx.strokeStyle = stroke;
            }
            ctx.lineWidth = lineWidth;
        }
        ctx.beginPath();
        if ( radius.length > 1 ) {
            var radiusIndex = 0;
            ctx.beginPath();
            //
            // top left
            //
            ctx.moveTo( 0, radius[ radiusIndex ] );
            if ( radius[ radiusIndex ] > 0 ) {
                ctx.arcTo( 0, 0, radius[ radiusIndex ], 0, radius[ radiusIndex ] );
            }
            //
            // top right
            //
            if ( radiusIndex < radius.length - 1 ) radiusIndex++;
            if ( radius[ radiusIndex ] > 0 ) {
                ctx.lineTo( width -radius[ radiusIndex ], 0 );
                ctx.arcTo( width, 0, width, radius[ radiusIndex ], radius[ radiusIndex ] );
            } else {
                ctx.lineTo( width, 0 );
            }
            //
            // bottom right
            //
            if ( radiusIndex < radius.length - 1 ) radiusIndex++;
            if ( radius[ radiusIndex ] > 0 ) {
                ctx.lineTo( width, height - radius[ radiusIndex ] );
                ctx.arcTo( width, height, width - radius[ radiusIndex ], height, radius[ radiusIndex ] );
            } else {
                ctx.lineTo( width, height );
            }
            //
            // bottom left
            //
            if ( radiusIndex < radius.length - 1 ) radiusIndex++;
            if ( radius[ radiusIndex ] > 0 ) {
                ctx.lineTo( radius[ radiusIndex ], height );
                ctx.arcTo( 0, height, 0, height - radius[ radiusIndex ], radius[ radiusIndex ] );
            } else {
                ctx.lineTo( 0, height );
            }
            ctx.closePath();
        } else if ( radius.length === 1 ) {
            ctx.roundedRect(0,0,width,height,radius[0],radius[0]);
        } else {
            ctx.rect(0,0,width,height);
        }
        if ( fill ) ctx.fill();
        if( lineWidth ) ctx.stroke();
    }
    //
    //
    //
    onFillChanged: {
        requestPaint();
    }
    onStrokeChanged: {
        requestPaint();
    }
    onLineWidthChanged: {
        requestPaint();
    }
    onRadiusChanged: {
        requestPaint();
    }
    //
    //
    //
    property var fill: null
    property var stroke: null
    property int lineWidth: 0
    property var radius: []
}
