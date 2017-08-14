import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "QUESTIONNAIRE"
    subtitle: questionnaires.currentItem.title || ""
    colour: Colours.blue
    //
    //
    //
    SwipeView {
        id: questionnaires
        //
        //
        //
        anchors.fill: parent
        anchors.bottomMargin: 36
        //
        //
        //
        clip: true
        //
        //
        //
        Repeater {
            id: questionnaireRepeater
            //
            //
            //
            model: questionnaireModel
            //
            //
            //
            delegate: Page {
                title: questionnaireModel.get(index).title
                //
                //
                //
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                //
                //
                //
                ListView {
                    anchors.fill: parent
                    anchors.bottomMargin: 36
                    clip: true
                    spacing: 8
                    model: questionnaireModel.get(index).questions
                    delegate: Question {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        question: model.question
                    }
                }
                //
                //
                //
                property string category: questionnaireModel.get(index).category
            }
        }
    }
    //
    //
    //
    AfterTrauma.PageIndicator {
        anchors.horizontalCenter: questionnaires.horizontalCenter
        anchors.bottom: questionnaires.bottom
        anchors.bottomMargin: 8
        currentIndex: questionnaires.currentIndex
        count: questionnaires.count
        colour: Colours.lightSlate
    }
    //
    //
    //
    footer: Item {
        height: 28
    }
    //
    //
    //
    StackView.onActivated: {
    }
}
