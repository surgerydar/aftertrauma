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
                    smooth: true
                    mipmap: true
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
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 8
                        horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter
                        visible: parent.status !== Image.Ready
                        font.family: fonts.light
                        font.pointSize: 24
                        color: Colours.veryDarkSlate
                        wrapMode: Label.WordWrap
                        text: "add a photo of your prescription"
                    }
                    //
                    //
                    //
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if( parent.status === Image.Ready ) {
                                zoomed.show('file://' + SystemUtils.documentDirectory() + '/' + prescription.image);
                            }
                        }
                    }
                }
                /*
                AfterTrauma.Button {
                    id: shareButton
                    anchors.bottom: parent.bottom
                    anchors.left: galleryButton.right
                    anchors.leftMargin: 1
                    text: "share"
                    backgroundColour: Colours.darkSlate
                    radius: [0]
                    onClicked: {
                        ShareDialog.shareFile("Prescription Image", SystemUtils.documentDirectory() + '/' + prescription.image );
                    }
                }
                */
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
                                onValueChanged: {
                                    prescription.goals[ index ].value = value / 100.;
                                    prescriptionsModel.update( {id:prescription.id},{goals: prescription.goals} );
                                    prescriptionsModel.save();
                                }
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
    ImageViewer {
        id: zoomed
        anchors.fill: parent
    }
    //
    //
    //
    function setImage(url) {
        console.log( 'PrescriptionPage.setImage : ' + url );
        prescriptionImage.source = 'file://' + url;
        //
        // update prescription
        //
        prescription.image = url.substring( url.lastIndexOf('/') + 1 );
        //
        // update database
        //
        var p = prescriptionsModel.get( prescriptionsView.currentIndex );
        if ( p ) {
            prescriptionsModel.update( {id:p.id},{image: prescription.image} );
            prescriptionsModel.save();
        }
    }

    //
    //
    //
    property var prescription: null
}
