import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    color: Colours.veryDarkSlate
    visible: false
    //
    //
    //
    Item {
        id: imageContainer
        anchors.fill: parent
        Image {
            id: image
            //transformOrigin: Item.Center
            //smooth: true
            //mipmap: true
            //
            //
            //
            onSourceChanged: {
                fitToContainer = true;
            }

            onStatusChanged: {
                if ( status === Image.Ready && fitToContainer ) {
                    fitToContainer = false;
                    console.log( 'image implicit [' + implicitWidth + ',' + implicitHeight + ']');
                    if ( sourceSize ) {
                        console.log( 'image source [' + sourceSize.width + ',' + sourceSize.height + ']');
                    }
                    console.log( 'image container [' + imageContainer.width + ',' + imageContainer.height + ']');
                    image.scale = Math.min( imageContainer.width / implicitWidth, imageContainer.height / implicitHeight );
                    image.x = ( imageContainer.width - ( implicitWidth * image.scale ) ) / 2.
                    image.y = ( imageContainer.height - ( implicitHeight * image.scale ) ) / 2.
                    initialWidth = implicitWidth;
                    initialHeight = implicitHeight;
                    console.log( 'image [' + image.width + ',' + image.height + ']')
                }
            }
            /*
            onScaleChanged: {
                sourceSize.width = initialWidth * scale;
                sourceSize.height = initialHeight * scale;
                console.log( 'image source [' + sourceSize.width + ',' + sourceSize.height + ']');
                console.log( 'image [' + image.width + ',' + image.height + ']')
            }
            */
            property real initialWidth: width
            property real initialHeight: height
            property bool fitToContainer: true
        }
        //
        //
        //
        PinchArea {
            id: pinchArea
            anchors.fill: parent
            //
            //
            //
            onPinchStarted: {
                initialScale = image.scale;
                startX = pinch.center.x;
                startY = pinch.center.y;
                initialX = image.x;
                initialY = image.y;
            }

            onPinchUpdated: {
                image.scale = initialScale * pinch.scale;
                image.x = initialX + ( pinch.center.x - startX );
                image.y = initialY + ( pinch.center.y - startY );
                console.log( 'pinchUpdated : x=' + image.x + ' y=' + image.y );
            }

            onPinchFinished: {
                //
                // TODO: reset to bounds
                //
                bounce.bounce();
            }
            //
            //
            //
            MouseArea {
                id: dragArea
                anchors.fill: parent
                //
                //
                //
                onPressed: {
                    pinchArea.startX = mouseX;
                    pinchArea.startY = mouseY;
                    pinchArea.initialX = image.x;
                    pinchArea.initialY = image.y;
                }
                onPositionChanged: {
                    image.x = pinchArea.initialX + ( mouseX - pinchArea.startX );
                    image.y = pinchArea.initialY + ( mouseY - pinchArea.startY );
                    console.log( 'positionChanged : x=' + image.x + ' y=' + image.y );
                }
                onReleased: {
                    bounce.bounce();
                }
            }
            //
            //
            //
            ParallelAnimation {
                id: bounce
                 NumberAnimation {
                    target: image; property: "scale";
                    duration: bounce.duration; easing.type: bounce.easing
                    to: bounce.targetScale
                }
                NumberAnimation {
                    target: image; property: "x"
                    duration: bounce.duration; easing.type: bounce.easing
                    to: bounce.targetX
                }
                NumberAnimation {
                    target: image; property: "y"
                    duration: bounce.duration; easing.type: bounce.easing
                    to: bounce.targetY
                }
                //
                //
                //
                function bounce() {
                    console.log('bounce : childrenRect: ' +
                                imageContainer.childrenRect.x + ',' + imageContainer.childrenRect.y + ',' +
                                imageContainer.childrenRect.width + ',' + imageContainer.childrenRect.height );

                    var minScale = Math.min( imageContainer.width / image.implicitWidth, imageContainer.height / image.implicitHeight );
                    var maxScale = Math.max( image.implicitWidth / imageContainer.width, image.implicitHeight / imageContainer.height ) * 4.;

                    targetScale = Math.max( minScale, Math.min( maxScale, image.scale) );
                    var targetWidth = image.implicitWidth * targetScale;
                    var targetHeight = image.implicitHeight * targetScale;
                    var offsetX = ( targetWidth - image.width ) / 2.;
                    var offsetY = ( targetHeight - image.height ) / 2.;

                    var minX = 0;
                    var maxX = 0;
                    if ( targetWidth > imageContainer.width ) {
                        minX = imageContainer.width - targetWidth;
                        maxX = 0.;
                        console.log( 'targetWidth > imageContainer.width : minX=' + minX + ' maxX=' + maxX );
                    } else {
                        minX = maxX = ( imageContainer.width - targetWidth ) / 2.;
                        console.log( 'targetWidth <= imageContainer.width : minX=' + minX + ' maxX=' + maxX );
                    }
                    var minY = 0;
                    var maxY = 0;
                    if ( targetHeight > imageContainer.height ) {
                        minY = imageContainer.height - targetHeight;
                        maxY = 0.;
                        console.log( 'targetHeight > imageContainer.height : minY=' + minY + ' maxY=' + maxY );
                    } else {
                        minY = maxY = ( imageContainer.height - targetHeight ) / 2.;
                        console.log( 'targetHeight <= imageContainer.height : minY=' + minY + ' maxY=' + maxY );
                    }
                    console.log( 'image.x=' + image.x + ' image.y=' + image.y );
                    //
                    // TODO: resize image
                    //
                    minX += offsetX;
                    maxX += offsetX;
                    minY += offsetY;
                    maxY += offsetY;

                    targetX = Math.max( minX, Math.min( maxX, image.x ) );
                    targetY = Math.max( minY, Math.min( maxY, image.y ) );

                    start();
                }
                onStopped: {
                    console.log( 'bounce.stopped : image.x=' + image.x + ' image.y=' + image.y );
                }

                //
                //
                //
                property real targetScale: 1.
                property real targetX: 0.
                property real targetY: 0.
                property int duration: 250
                property var easing: Easing.InOutQuad
            }
            //
            //
            //
            property real initialScale: 1.
            property real initialX: 0.
            property real initialY: 0.
            property real startX: 0.
            property real startY: 0.
        }
    }

    //
    //
    //
    AfterTrauma.Button {
        id: closeButton
        width: 48
        height: 48
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        image: "icons/close.png"
        onClicked: {
            hide();
        }
    }
    //
    //
    //
    function show( imageSource ) {
        parent = appWindow.contentItem;
        image.source = imageSource;
        visible = true;
    }
    function hide() {
        visible = false;
        parent = originalParent;
        image.source = "";
    }
    //
    //
    //
    property alias source: image.source
    property Item originalParent: parent
}
