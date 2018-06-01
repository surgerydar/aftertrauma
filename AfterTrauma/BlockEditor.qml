import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    height: parent.height
    y: parent.height
    anchors.left: parent.left
    anchors.right: parent.right
    color: Colours.darkSlate
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "closed"
            PropertyChanges {
                target: container
                y: container.height
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: container
                y: 0
            }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
    //
    //
    //
    function open() {
        container.state = "open";
    }
    function close() {
        container.state = "closed";
    }
    //
    // titlebar
    //
    Item {
        id: titlebar
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "cancel"
            onClicked: {
                container.close();
            }
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "save"
            onClicked: {
                container.close();
            }
        }
    }
    //
    // optional date picker
    //
    AfterTrauma.DatePicker {
        id: date
        height: 128
        width: container.width - 8
        anchors.top: titlebar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: showDate
        textMonth: true
    }
    //
    //
    //
    TabBar {
        id: mediaType
        //
        //
        //
        height: 64
        width: container.width - 8
        anchors.top: showDate ? date.bottom : titlebar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 8
        //
        //
        //
        TabButton {
            text: "text"
            font.family: fonts.light
            font.pointSize: 24
        }
        TabButton {
            text: "image"
            font.family: fonts.light
            font.pointSize: 24
        }
    }
    //
    //
    //
    SwipeView {
        id: media
        width: container.width - 8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: mediaType.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        clip: true
        currentIndex: mediaType.currentIndex
        Page {
            AfterTrauma.TextArea {
                id: textMedia
                anchors.fill: parent
                padding: 8
                placeholderText: "type a note"
            }
        }
        Page {
            Image {
                id: imageMedia
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: galleryButton.top
                anchors.right: parent.right
                fillMode: Image.PreserveAspectFit
            }
            AfterTrauma.Button {
                id: galleryButton
                anchors.bottom: parent.bottom
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 1
                text: "gallery"
                backgroundColour: Colours.darkSlate
                radius: [0]
                onClicked: {
                    ImagePicker.openGallery();
                }
            }
            AfterTrauma.Button {
                id: cameraButton
                anchors.bottom: parent.bottom
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: 1
                text: "camera"
                backgroundColour: Colours.darkSlate
                radius: [0]
                onClicked: {
                    ImagePicker.openCamera();
                }
            }
        }
    }
    //
    //
    //
    Connections {
        target: ImagePicker
        onImagePicked: {
            var source = 'file://' + url;
            console.log( 'image picked : ' + source );
            imageMedia.source = source;
            //images[imagesView.currentIndex].image = source;
            //imagesView.currentItem.image = images[imagesView.currentIndex].image;
            //setImageTimer.source = source;
            //setImageTimer.start();
        }
    }
    //
    //
    //
    function show( withDate, mediaType, content ) {
        showDate = withDate;
        if ( mediaType ) {
            media.currentIndex = mediaType === "image" ? 1 : 0
        }
        if ( content ) {
            textMedia.text = mediaType === "text" ? content : ""
            imageMedia.source = mediaType === "image" ? content : ""
        } else {
            textMedia.text = "";
            imageMedia.source = "";
        }
        //
        //
        //
        open();
    }

    property bool showDate: false
    property string type: "text"
}
