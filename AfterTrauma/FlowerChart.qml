import QtQuick 2.6
import QtQuick.Controls 2.1
import "flowerChart.js" as Flower
Canvas {
    id: control

    onPaint: {
        /*
        if ( data.length > 0 ) {
            var angleIncr = 360 / data.length;
            data.forEach( function( data ) {
                if ( data[ 0 ] === currentYear ) {

                }
            });
        }
        */
        var ctx = getContext("2d");
        Flower.draw(ctx);
    }
    //
    //
    //
    function animate() {
        var moreFrames = Flower.update();
        control.requestPaint();
        if( moreFrames ) {
            animationHandle = requestAnimationFrame(animate);
        }
    }

    function setCurrentDate(date) {
        if ( currentDate !== date ) {
            currentDate = date;
            Flower.setCurrentDate(date);
            Flower.startAnimation();
            animate();
        }
    }
    //
    //
    //
    signal dateRangeChanged( var startDate, var endDate );
    //
    //
    //
    property var animationHandle: null
    property int currentDate: 0
    //
    //
    //
    Component.onCompleted: {
        Flower.useTestData();
        setCurrentDate(Flower.startDate);
        console.log( 'FlowerChart - startDate:' + Flower.startDate + ' endDate:' + Flower.endDate );
        control.dateRangeChanged(new Date(Flower.startDate), new Date(Flower.endDate));
    }
}
