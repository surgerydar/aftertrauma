import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    title: "QUESTIONNAIRE"
    subtitle: "Subject"
    colour: Colours.blue
    //
    //
    //
    ListView {
        id: questionList
        //
        //
        //
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 8
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: Question {
            anchors.left: parent.left
            anchors.right: parent.right
            question: model.question
            score: model.score
        }
    }
    //
    //
    //
    StackView.onActivated: {
        var data = [
                    { question: "question one", score: 0. },
                    { question: "question two", score: 0. },
                    { question: "question three", score: 0. },
                    { question: "question four", score: 0. },
                    { question: "question five", score: 0. },
                    { question: "question six", score: 0. },
                    { question: "question seven", score: 0. },
                    { question: "question eight", score: 0. }
                ];
        questionList.model.clear();
        data.forEach(function(datum) {
            questionList.model.append(datum);
        });
    }
}
