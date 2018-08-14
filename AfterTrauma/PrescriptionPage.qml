import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

Page {
    id: container
    //
    //
    //
    Flickable {
        id: prescriptionContainer
        anchors.fill: parent
        contentHeight: prescriptionItems.childrenRect.height + 16
        clip: true
        //
        //
        //
        Column {
            id: prescriptionItems
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 4
            Rectangle {
                id: imageBlock
                width: prescriptionContainer.width
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                color: Colours.almostWhite
                //
                //
                //
                Image {
                    id: prescriptionImage
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: galleryButton.top
                    anchors.right: parent.right
                    anchors.margins: 16
                    fillMode: Image.PreserveAspectFit
                    source: prescription ? 'file://' + SystemUtils.documentDirectory() + '/' + prescription.image : ""
                    onStatusChanged: {
                        if( status === Image.Error ) {
                            source = "";
                        }
                    }
                    //
                    //
                    //
                    Label {
                        anchors.centerIn: parent
                        horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter
                        visible: parent.status !== Image.Ready
                        font.family: fonts.light
                        font.pointSize: 24
                        color: Colours.veryDarkSlate
                        wrapMode: Label.WordWrap
                        text: "add image of your prescription"
                    }
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
            //
            //
            //
            Rectangle {
                id: goalsBlock
                height: childrenRect.height + 16
                anchors.horizontalCenter: parent.horizontalCenter
                width: prescriptionContainer.width
                color: Colours.lightSlate
                Label {
                    id: goalsHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 8
                    color: Colours.veryDarkSlate
                    fontSizeMode: Label.Fit
                    font.family: fonts.light
                    font.pointSize: 24
                    text: "Goals"
                }
                Column {
                    anchors.top: goalsHeader.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 4
                    width: parent.width
                    Repeater {
                        model: prescription ? prescription.goals.length : 0
                        Item {
                            width: goalsBlock.width
                            height: 48
                            Label {
                                id: nameLabel
                                width: parent.width / 3
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 8
                                font.family: fonts.light
                                font.pointSize: 18
                                verticalAlignment: Label.AlignVCenter
                                horizontalAlignment: Label.AlignRight
                                text: prescription.goals[ index ].name
                            }
                            AfterTrauma.Slider {
                                id: valueSlider
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: nameLabel.right
                                anchors.right: parent.right
                                anchors.margins: 8
                                from: 0; to: 100;
                                value: prescription.goals[ index ].value * 100
                            }
                        }
                    }
                }
            }
        }
    }
    //
    //
    //
    function setImage(url) {
        console.log( 'PrescriptionPage.setImage : ' + url );
        prescriptionImage.source = 'file://' + url;
        //
        //
        //
        var prescription = prescriptionsModel.get( prescriptionsView.currentIndex );
        if ( prescription ) {
            prescription.image = url.substring( url.lastIndexOf('/') + 1 );
            prescriptionsModel.update( {id:prescription.id},{image: url.substring( url.lastIndexOf('/') + 1 )} );
            prescriptionsModel.save();
        }
    }

    //
    //
    //
    property var prescription: null
}
