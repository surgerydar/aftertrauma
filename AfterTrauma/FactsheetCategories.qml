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
        //
        //
        //
        height: Math.min( parent.height, contentHeight )
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 16
        //
        //
        //
        interactive: contentHeight >= parent.height
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: FactsheetItem {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            textSize: 48
            text: model.title || ""
            backgroundColour: Colours.categoryColour(model.index)
            radius: model.index === 0 ? [8,8,0,0] : model.index === categories.model.count - 1 ? [0,0,8,8] : [0]
            onClicked: {
                stack.push( "qrc:///FactsheetCategory.qml", { title: model.title, colour: Colours.categoryColour(model.index), content: model.content });
            }
        }
        //
        //
        //
        add: Transition {
            NumberAnimation { properties: "y"; from: categories.height; duration: 250 }
        }
    }

    StackView.onActivated: {
        /*
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
        */
        categories.model.clear();
        JSONFile.read('/factsheets/categories.json');
    }
    //
    //
    //
    Connections {
        target: JSONFile

        onArrayReadFrom: {
            console.log( 'path:' + path );
            console.log( 'array:' + JSON.stringify(array) );
            categories.model.clear();
            array.forEach(function(entry) {
                categories.model.append(entry);
            });
        }
        onObjectReadFrom: {
            console.log( 'path:' + path );
            console.log( 'object:' + JSON.stringify(object) );
        }
        onErrorReadingFrom: {
            console.log( 'path:' + path );
            console.log( 'error:' + error );
        }
    }

}
