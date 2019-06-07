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
    title: "MY REHAB"
    subtitle: prescriptionsView.count > 0 ? Utils.shortDate(prescriptionsRepeater.itemAt(prescriptionsView.currentIndex).prescription.date) : ""
    colour: Colours.blue
    //
    //
    //
    SwipeView {
        id: prescriptionsView
        anchors.fill: parent
        //anchors.bottomMargin: 36
        //
        //
        //
        Repeater {
            id: prescriptionsRepeater
            delegate: PrescriptionPage {
                prescription: prescriptionsModel.get(index)
            }
        }
    }
    //
    //
    //
    Label {
        id: addPrompt
        anchors.centerIn: prescriptionsView
        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter
        visible: prescriptionsModel.count === 0
        font.family: fonts.light
        font.pointSize: 24
        color: Colours.veryDarkSlate
        wrapMode: Label.WordWrap
        text: "add your prescription here"
    }
    //
    //
    //
    footer: Rectangle {
        id: footerItem
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        color: Colours.blue
        AfterTrauma.PageIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: prescriptionsView.currentIndex
            count: prescriptionsView.count
            colour: Colours.lightSlate
        }
        AfterTrauma.Button {
            id: addButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: 8
            image: "icons/add.png"
            backgroundColour: "transparent"
            onClicked: {
                var p = {
                    id: GuidGenerator.generate(),
                    date: Date.now(),
                    image: "",
                    goals: [
                        { name: 'emotions', value: 1.0 },
                        { name: 'confidence', value: 1.0 },
                        { name: 'body', value: 1.0 },
                        { name: 'life', value: 1.0 },
                        { name: 'relationships', value: 1.0 }
                    ]
                };
                prescriptionsModel.add(p);
                prescriptionsRepeater.model = prescriptionsModel.count;
                addPrompt.visible = prescriptionsModel.count === 0;
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        prescriptionsRepeater.model = prescriptionsModel.count;
    }
    StackView.onDeactivating: {
    }
    //
    //
    //
    Connections {
        target: ImagePicker
        onImagePicked: {
            prescriptionsRepeater.itemAt(prescriptionsView.currentIndex).setImage( url );
        }
    }
    //
    //
    //
}
