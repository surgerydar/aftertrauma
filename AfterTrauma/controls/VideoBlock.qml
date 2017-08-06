import QtQuick 2.6
import QtQuick.Controls 2.1
import QtMultimedia 5.8

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max( 64, output.contentRect.height + 16 )
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
    MediaPlayer {
        id: content
        onPlaybackStateChanged: {

        }
    }
    VideoOutput {
        id: output
        //
        //
        //
        height: Math.min(width * ( sourceRect.height / sourceRect.width ),sourceRect.height)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        fillMode: VideoOutput.PreserveAspectFit
        source: content
        MouseArea {
            id: play
            anchors.fill: parent
            onClicked: {
                if ( content.playbackState !== MediaPlayer.PlayingState ) {
                    content.play();
                } else {
                    content.pause();
                }
            }
            onPositionChanged: {
                if ( content.status === MediaPlayer.Loaded ) {
                    var position = content.duration * ( output.width / mouseX );
                    content.seek( position );
                }
            }
        }
        Image {
            id: playButton
            anchors.centerIn: parent
            source: "../icons/right_arrow.png"
            visible: content.status === MediaPlayer.Loaded && content.playbackState !== MediaPlayer.PlayingState
        }
    }
    onImplicitHeightChanged: {
        console.log( 'implicitHeight:' + implicitHeight + ' width:' + width + ' height:' + height )
    }

    //
    //
    //
    BusyIndicator {
        anchors.centerIn: parent
        running: content.status === MediaPlayer.Loading
    }
    //
    // TODO: ErrorIndicator
    //
    //
    //
    //
    property alias media: content.source
}
