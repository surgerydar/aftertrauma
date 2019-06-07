import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    //height: Math.max(64,childrenRect.height)
    height: blockLoader.item ? Math.max(64,blockLoader.item.height) : 64
    implicitHeight: blockLoader.item ? Math.max(64,blockLoader.item.height) : 64
    //
    //
    //
    Component {
        id: text
        TextBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Component {
        id: image
        ImageBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Component {
        id: video
        VideoBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Loader {
        id: blockLoader
        //anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        onLoaded: {
            item.mediaReady.connect(mediaReady);
            item.media = container.media;

        }
    }
    //
    //
    //
    Component.onCompleted: {
        blockLoader.sourceComponent = type === "video" ? video : type === "image" ? image : text;
    }
    //
    //
    //
    onTypeChanged: {
        blockLoader.sourceComponent = type === "video" ? video : type === "image" ? image : text;
    }
    onMediaChanged: {
        if ( blockLoader.status === Loader.Ready ) {
            blockLoader.item.media = media;
        }
    }
    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    //
    //
    //
    property string type: "text" // "text" | "image" | "video"
    property string media: ""
    property alias content: blockLoader.item
}
