import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container

    title: "RESOURCES"
    colour: Colours.darkOrange
    //
    //
    //
    ListView {
        id: categories
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
        delegate: AfterTrauma.Button {
            height: 64
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            textSize: 48
            //textFit: Text.Fit
            text: model.title
            backgroundColour: Colours.categoryColour(model.index)
            radius: model.index === 0 ? [8,8,0,0] : model.index === categories.model.count - 1 ? [0,0,8,8] : [0]
            onClicked: {
                stack.push( "qrc:///FactsheetCategory.qml", { title: model.title, colour: Colours.categoryColour(model.index), contents: model.contents });
            }
        }
    }

    StackView.onActivated: {
        //
        // TODO: get this from database
        //
        var data  = [
                    { title: "EMOTIONS",
                        contents: [
                            { title: "Introduction", factsheet: "emotions.introduction" },
                            { title: "Coming home from hospital: common feelings", factsheet: "emotions.cominghomefromhospital" },
                            { title: "Stress after trauma", factsheet: "emotions.stressaftertrauma" },
                            { title: "Depression", factsheet: "emotions.depression" },
                            { title: "Managing difficult feelings", factsheet: "emotions.managingdifficultfeelings" },
                            { title: "How to help a loved one", factsheet: "emotions.howtohelpalovedone" },
                            { title: "When do I ask for help?", factsheet: "emotions.whendoiaskforhelp" },
                            { title: "Treatment approaches", factsheet: "emotions.treatmentapproaches" },
                            { title: "Helpful organisations", factsheet: "emotions.helpfulorganisations" },
                        ]
                    },
                    { title: "BODY",
                        contents: [
                        ]
                    },
                    { title: "MIND",
                        contents: [
                        ]
                    },
                    { title: "LIFE",
                        contents: [
                        ]
                    },
                    { title: "RELATIONSHIPS",
                        contents: [
                        ]
                    },
                    { title: "FOR CARERS",
                        contents: [
                        ]
                    },
                    { title: "SERVICES",
                        contents: [
                        ]
                    },
                    { title: "TRAUMA SURVIVOR AND CARER STORIES",
                        contents: [
                        ]
                    },
                ];
        categories.model.clear();
        data.forEach(function(datum) {
            categories.model.append(datum);
        });
    }
}
