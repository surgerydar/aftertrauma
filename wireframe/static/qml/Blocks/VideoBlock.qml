import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.8

VideoOutput {
    id: container
    width: parent.width
    height: contentRect.height > 0 && contentRect.width > 0 ? width * ( contentRect.height / contentRect.width ) : width * 0.5625
    source: player
    //
    //
    //
    property alias media: player.source
    //
    //
    //
    onWidthChanged: { 
        if ( contentRect.height > 0 && contentRect.width > 0 ) {
            var aspect = contentRect.height / contentRect.width;
            console.log( 'aspect:' + aspect );
            height = width * aspect;
        } else {
            height = width * 0.5625
        }
    }
    Component.onCompleted: {
        container.height = contentRect.height > 0 && contentRect.width > 0 ? width * ( contentRect.height / contentRect.width ) : width * 0.5625
    }
    //
    //
    //
    MediaPlayer {
        id: player
        autoLoad: false
        property bool playing: false
        onError: {
            if (MediaPlayer.NoError != error) {
                console.log("VideoBlock.onError error " + error + " errorString " + errorString)
            }
        }
        onStatusChanged: {
            var statusDesc = "Unknown"
            switch( status ) {
                case MediaPlayer.NoMedia:
                    statusDesc = "no media has been set"
                    break;
                case MediaPlayer.Loading:
                    statusDesc = "the media is currently being loaded"
                    break;
                case MediaPlayer.Loaded:
                    statusDesc = "the media has been loaded";
                    break;
                case MediaPlayer.Buffering:
                    statusDesc = 'the media is buffering data';
                    break;
                case MediaPlayer.Stalled:
                    statusDesc = "playback has been interrupted while the media is buffering data";
                    break;
                case MediaPlayer.Buffered:
                    statusDesc = "the media has buffered data";
                    break;
                case MediaPlayer.EndOfMedia:
                    statusDesc = "the media has played to the end";
                    break;
                case MediaPlayer.InvalidMedia:
                    statusDesc = "the media cannot be played";
                    break;
                case MediaPlayer.UnknownStatus:
                    statusDesc = "the status of the media is unknown";
                    break;
            }
            console.log("VideoItem.onStatusChanged status:" + statusDesc);
        }
        onPlaying: {
            playing = true
        }
        onPaused: {
            playing = false;
        }
        onStopped: {
            playing = false;
            seek(0);
        }
    }
    //
    //
    //
    Image {
        id: indicator
        width: 48
        height: 48
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        opacity: player.playing ? 0. : 1.
        source: "icons/play_circle-black.png"
        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if ( player.playing ) {
                player.pause();
            } else {
                player.play();
            }
        }
    }
}
