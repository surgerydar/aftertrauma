import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "CHALLENGES"
    colour: Colours.lightGreen
    //
    //
    //
    ListView {
        id: challenges
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
        delegate: ChallengeManagerItem {
            anchors.left: parent.left
            anchors.right: parent.right
            name: model.name
            activity: model.activity
            count: model.count
        }
    }
    //
    //
    //
    AfterTrauma.Button {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        image: "icons/add.png"
        backgroundColour: "transparent"
        //
        //
        //
        onClicked: {
            stack.push( "qrc:///ChallengeBuilder.qml")
        }
    }
    //
    //
    //
    StackView.onActivated: {
        //
        // TODO: get this from database
        //
        var data  = [
                    {
                        name: "Lying Back Excercise",
                        activity: "Lie on your back with both of your legs straight. In this position, bring your left knee up close to your chest. Hold this position for 10 seconds. Return your leg to the straight position. Repeat with the right leg.",
                        repeats: 5,
                        frequency: "morning and evening",
                        count: 0
                    },
                    {
                        name: "Standing Back Excercise",
                        activity: "Stand up with your arms on your side. Bend to the left side while slowly sliding your left hand down your left leg. Come back up slowly and relax. Repeat with the right side of your body.",
                        repeats: 10,
                        frequency: "daily",
                        count: 0
                    },
                    {
                        name: "Neck stretch up",
                        activity: "Keep your eyes centred on one object directly in front of you, now slowly move your head back. You will now be looking at the roof. Keep your whole body still. Hold this position for 5 seconds and slowly return your head to the start position.",
                        repeats: 3,
                        frequency: "hourly",
                        count: 0
                    },
                    {
                        name: "Foot writing",
                        activity: "Barefooot write digits 1 to 10 using your toes raised up in the air.",
                        repeats: 1,
                        frequency: "weekly",
                        count: 0
                    },

                ];
        challenges.model.clear();
        data.forEach(function(datum) {
            challenges.model.append(datum);
        });
    }
}
