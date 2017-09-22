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
        onStatusChanged: {
            console.log('MediaPlayer status:' + status);
            switch( status ) {
            case MediaPlayer.NoMedia :
                console.log( "no media has been set" );
                break;
            case MediaPlayer.Loading :
                console.log( "the media is currently being loaded");
                break;
            case MediaPlayer.Loaded :
                console.log( "the media has been loaded");
                break;
            case MediaPlayer.Buffering :
                console.log( "the media is buffering data");
                break;
            case MediaPlayer.Stalled :
                console.log( "playback has been interrupted while the media is buffering data");
                break;
            case MediaPlayer.Buffered :
                console.log( "the media has buffered data");
                break;
            case MediaPlayer.EndOfMedia :
                console.log( "the media has played to the end");
                break;
            case MediaPlayer.InvalidMedia :
                console.log( "the media cannot be played");
                break;
            case MediaPlayer.UnknownStatus :
                console.log( "the status of the media is unknown");
                break;
            }
        }
        onPlaybackStateChanged: {

        }
        onError: {
            var currentSource = JSON.stringify(source);
            var mediaPath = 'file://' + SystemUtils.documentDirectory() + '/media' + currentSource.substring(currentSource.lastIndexOf('/'));
            console.log( 'redirecting video block from ' + currentSource + ' to : ' + mediaPath );
            source = mediaPath;
        }
    }
    VideoOutput {
        id: output
        //
        //
        //
        height: width * ( 9. / 16. )//Math.min(width * ( sourceRect.height / sourceRect.width ),sourceRect.height)
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
                    console.log( 'play' );
                    content.play();
                } else {
                    console.log( 'pause' );
                    content.pause();
                }
            }
            /*
            onPositionChanged: {
                if ( content.status === MediaPlayer.Loaded ) {
                    var position = content.duration * ( output.width / mouseX );
                    content.seek( position );
                }
            }
            */
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
