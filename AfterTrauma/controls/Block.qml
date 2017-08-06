import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max(64,childrenRect.height)
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
    /*
    Text {
        z: 2
        anchors.fill: parent
        text: type + ':' + media
    }
    */
    Loader {
        id: blockLoader
        //anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        onLoaded: {
            item.media = container.media;
        }
    }
    Component.onCompleted: {
        blockLoader.sourceComponent = type === "video" ? video : type === "image" ? image : text;
    }

    property string type: "text" // "text" | "image" | "video"
    property string media: ""
}
