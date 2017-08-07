import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "IMAGES"
    colour: Colours.blue
    //
    //
    //
    ListView {
        id: images
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: ImageItem {
            anchors.left: parent.left
            anchors.right: parent.right
            source: model.image
        }
    }
    //
    //
    //
    footer: Item {
        id: toolbar
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            id: addImageLibrary
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 8
            anchors.bottomMargin: 64

            backgroundColour: colour
            image: "icons/add.png"
            text: "gallery"
            //
            //
            //
            onClicked: {
                ImagePicker.openGallery();
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            id: addImageCamera
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8
            anchors.bottomMargin: 64
            direction: "Right"
            backgroundColour: colour
            image: "icons/add.png"
            text: "camera"
            //
            //
            //
            onClicked: {
                ImagePicker.openCamera();
            }
        }
    }
    //
    //
    //
    onDateChanged: {
        subtitle = Utils.shortDate( date );
    }

    //
    //
    //
    StackView.onActivated: {
        //
        // TODO: get this from database
        //
        var data  = {
            date: Date.now(),
            images:[
                { image: "icons/title_logo.png" },
                { image: "icons/title_logo.png" },
                { image: "icons/title_logo.png" }
            ]
        };
        date = data.date;
        images.model.clear();
        data.images.forEach(function(image) {
            images.model.append(image);
        });
    }
    //
    //
    //
    Connections {
        target: ImagePicker
        onImagePicked: {
            images.model.append({image:'file://'+url});
        }
    }

    //
    //
    //
    property var date: Date.now()
}
