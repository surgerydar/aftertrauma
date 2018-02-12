import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max(64,content.height + 16)
    //implicitHeight: Math.max(64,content.paintedHeight + 16)
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        radius: [4]
    }
    //
    //
    //
    Image {
        id: content
        //
        //
        //
        height: Math.min(width * ( sourceSize.height / sourceSize.width ),sourceSize.height)
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
            } else {
                container.height = Math.max(64,content.height + 16);
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
    property bool redirected: false
    property string media: ""
}
