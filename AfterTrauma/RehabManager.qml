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
    title: "MY REHAB PLAN"
    subtitle: rehabPages.count > 0 ? Utils.shortDate(rehabPages.itemAt(rehabPages.currentIndex).plan.date) : ""
    colour: Colours.blue
    //
    //
    //
    SwipeView {
        id: rehabPages
        anchors.fill: parent
        //anchors.bottomMargin: 36
        //
        //
        //
        Repeater {
            id: rehabRepeater
            delegate: RehabPage {
                plan: rehabModel.get(index)
            }
        }
    }
    //
    //
    //
    AfterTrauma.Label {
        id: addPrompt
        anchors.fill: rehabPages
        visible: rehabModel.count === 0
        font.family: fonts.light
        font.pointSize: 24
        color: Colours.almostWhite
        text: "add your rehab plan here"
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
        Item {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: addButton.left
            AfterTrauma.Button {
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                image: "icons/left_arrow.png"
                visible: rehabPages.currentIndex > 0
                onClicked: {
                    rehabPages.decrementCurrentIndex();
                }
            }
            AfterTrauma.PageIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                currentIndex: rehabPages.currentIndex
                count: rehabPages.count
                colour: Colours.lightSlate
            }
            AfterTrauma.Button {
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                image: "icons/right_arrow.png"
                visible: rehabPages.currentIndex < rehabPages.count - 1
                onClicked: {
                    rehabPages.incrementCurrentIndex();
                }
            }
        }
        AfterTrauma.Button {
            id: addButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: 8
            image: "icons/add.png"
            backgroundColour: "transparent"
            visible: rehabModel.getIndexForDate( new Date() ) < 0
            onClicked: {
                var planIndex = rehabModel.getIndexForDate( new Date() );
                if ( planIndex >= 0 ) {
                    rehabPages.currentIndex = planIndex;
                    rehabPages.itemAt(planIndex).openEditor();
                } else {
                    var plan = {
                        id: GuidGenerator.generate(),
                        date: Date.now(),
                        blocks: [],
                        goals: [
                            { name: 'emotions', value: 1.0 },
                            { name: 'confidence', value: 1.0 },
                            { name: 'body', value: 1.0 },
                            { name: 'life', value: 1.0 },
                            { name: 'relationships', value: 1.0 }
                        ]
                    };
                    rehabModel.add(plan);
                    rehabRepeater.model = rehabModel.count;
                    addPrompt.visible = rehabModel.count === 0;
                }
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        rehabRepeater.model = rehabModel.count;
    }
    StackView.onDeactivating: {
    }
    //
    //
    //
}
