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
            enabled: ( type === "text" && textMedia.text.length > 0 ) || ( type === "image" && imageMedia.status === Image.Ready )
            onClicked: {
                if ( callback ) {
                    callback( type, type === "text" ? textMedia.text : imageSource, date.currentDate );
                }
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
        id: mediaTypeSelector
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
        anchors.top: mediaTypeSelector.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        clip: true
        currentIndex: mediaTypeSelector.currentIndex
        Page {
            /*
            AfterTrauma.TextArea {
                id: textMedia
                anchors.fill: parent
                anchors.topMargin: activeFocus ? 32 : 0 // acommodate "done" button
                anchors.bottomMargin: activeFocus ? height / 2 : 0
                padding: 8
                wrapMode: TextArea.Wrap
                placeholderText: "type a note"
                showPlaceholderPrompt: true // TODO: this is just to compensate for placeholder text colour being the same as the background colour

            }
            */
            /*
            Flickable {
                   id: flick
                   anchors.fill: parent
                   //contentWidth: textMedia.contentHeight
                   contentHeight: textMedia.height + ( textMedia.padding * 2 )
                   clip: true

                   function ensureVisible(r) {
                       if (contentX >= r.x)
                           contentX = r.x;
                       else if (contentX+width <= r.x+r.width)
                           contentX = r.x+r.width-width;
                       if (contentY >= r.y)
                           contentY = r.y;
                       else if (contentY+height <= r.y+r.height)
                           contentY = r.y+r.height-height;
                   }

                   AfterTrauma.TextArea {
                       id: textMedia
                       width: flick.width
                       height: Math.max(contentHeight,flick.height)
                       focus: true
                       padding: 8
                       wrapMode: TextArea.Wrap
                       placeholderText: "type a note"
                       showPlaceholderPrompt: true // TODO: this is just to compensate for placeholder text colour being the same as the background colour
                       onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                   }
               }
               */
            AfterTrauma.ScrollableTextArea {
                id: textMedia
                anchors.fill: parent
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

        onCurrentIndexChanged: {
            type = currentIndex === 0 ? "text" : "image";
        }

    }
    //
    //
    //
    Connections {
        id: imagePickerConnection
        target: ImagePicker
        onImagePicked: {
            if ( container.state === "open" ) {
                /*
                if ( ImageUtils.resize(url, appWindow.width, appWindow.height) ) {
                    imageSource = url.substring( url.lastIndexOf('/') + 1 );
                    console.log( 'image picked : ' + imageSource );
                    imageMedia.source = 'file://' + url;
                }
                */
                imageSource = url.substring( url.lastIndexOf('/') + 1 );
                console.log( 'image picked : ' + imageSource );
                imageMedia.source = 'file://' + url;
            }
        }
    }
    //
    //
    //
    function show( withDate, callbackFunction, mediaType, content ) {
        showDate = withDate;
        if ( mediaType ) {
            type = mediaType;
            mediaTypeSelector.currentIndex = mediaType === "image" ? 1 : 0
        } else {
            type = "text";
            mediaTypeSelector.currentIndex = 0;
        }

        if ( content ) {
            textMedia.text = mediaType === "text" ? content : ""
            imageSource = mediaType === "image" ? content : ""
            imageMedia.source = imageSource;
        } else {
            textMedia.text = "";
            imageSource = "";
            imageMedia.source = imageSource;
        }
        //
        //
        //
        callback = callbackFunction;
        //
        //
        //
        open();
    }

    property var callback: undefined
    property bool showDate: false
    property string type: "text"
    property string imageSource: ""
}
