import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Page {
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        color: Colours.blue
    }
    //
    //
    //
    Item {
        anchors.fill: parent
        anchors.bottomMargin: 32
        visible: imageItem.source == ""
        Row {
            anchors.centerIn: parent
            spacing: 16
            AfterTrauma.Button {
                id: galleryButton
                text: "Gallery"
                backgroundColour: Colours.blue
                onClicked: {
                    ImagePicker.openGallery();
                }
            }
            AfterTrauma.Button {
                id: cameraButton
                text: "Camera"
                backgroundColour: Colours.blue
                onClicked: {
                    ImagePicker.openCamera();
                }
            }
        }
    }
    //
    //
    //
    Image {
        id: imageItem
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: source != ""
    }
    property alias image: imageItem.source
}
