import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max(64,content.height + 16)
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        radius: [ 0 ]
    }
    //
    //
    //
    Image {
        id: content
        //
        //
        //
        height: Math.min(width * ( sourceSize.height / sourceSize.width ), sourceSize.height)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        fillMode: Image.PreserveAspectFit
        //
        //
        //
        onStatusChanged: {
            if ( status === Image.Error ) { // && !redirected ) {
                /*
                redirected = true;
                var currentSource = JSON.stringify(source);
                var mediaPath = 'file://' + SystemUtils.documentDirectory() + '/media' + currentSource.substring(currentSource.lastIndexOf('/'));
                console.log( 'redirecting image block from ' + currentSource + ' to : ' + mediaPath );
                source = mediaPath;
                */
                console.log('ImageBlock : error loading image : ' + source );
                mediaError( 'unable to load : ' + source );
            } else if ( status === Image.Ready ){
                /*
                //container.height = Math.max(64,content.paintedHeight + 16);
                console.log( 'ImageBlock sourceSize: [' + sourceSize.width + ',' + sourceSize.height + ']');
                console.log( 'ImageBlock size: [' + width + ',' + height + ']');
                console.log( 'ImageBlock container.size: [' + container.width + ',' + container.height + ']');
                height = Math.min(width * ( sourceSize.height / sourceSize.width ),sourceSize.height);
                container.height = Math.max(64, Math.min(width * ( sourceSize.height / sourceSize.width ),sourceSize.height) + 16);
                console.log( 'resizing ImageBlock to ' + container.height );
                */
                console.log('ImageBlock : loaded image : ' + source );
                mediaReady();
            }
        }
    }
    //
    //
    //
    onMediaChanged: {
        content.source = "image://cached/" + media;
    }
    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    //
    //
    //
    property bool redirected: false
    property string media: ""
}
