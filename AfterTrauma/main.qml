import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

ApplicationWindow {
    id: appWindow
    visible: true
    width: 480
    height: 640
    title: qsTr("AfterTrauma")
    //
    // global font
    //
    AfterTrauma.Fonts {
        id: fonts
        anchors.fill: parent
        z:10
    }
    //
    // global models
    //
    Daily {
        id: dailyModel
    }
    Timer {
        id: notificationTimer
        interval: 60 * 1000
        repeat: true
        onTriggered: {
            notificationModel.update();
        }
    }
    Notifications {
        id: notificationModel
    }
    Challenges {
        id: challengeModel
    }
    Questionnaires {
        id: questionnaireModel
    }
    Messages {
        id: messageModel
    }
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Colours.blue }
            GradientStop { position: 1.0; color: Colours.lightGreen }
        }
    }
    //
    //
    //
    FlowerChart {
        id: flowerChart
        height: width
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 16
        anchors.leftMargin: 8
        anchors.rightMargin: 8
    }
    //
    //
    //
    StackView {
        id: stack
        anchors.fill: parent
        anchors.topMargin: titleBar.height
        //anchors.bottomMargin: 28
    }
    //
    //
    //
    TitleBar {
        id: titleBar
    }
    NavigationBar {
        id: navigationBar
    }
    ShortcutPopup {
        id: shortcut
    }
    //
    //
    //
    Intro {
        id: intro
        modal: true
        x: 16
        y: 16
        width: appWindow.width - 32
        height: appWindow.height - 32
    }
    Register {
        id: register
        modal: true
        x: 16
        y: 16
        width: appWindow.width - 32
        height: appWindow.height - 32
    }
    AfterTrauma.ErrorDialog {
        id: errorDialog
        x: 0
        y: 0
        modal: true
        width: appWindow.width
        height: appWindow.height
    }
    //
    //
    //
    Component.onCompleted: {
        //
        // TODO: check settings for first use
        //
        if ( SystemUtils.isFirstRun() ) {
            intro.open();
            SystemUtils.install();
            //
            // generate test data
            //
            var week = 1000 * 60 * 60 * 24 * 7;
            for ( var i = 0; i < 52; i++ ) {
                var day = new Date(Date.now()-(week*i));
                var multiplier = ( ( 51 - i ) + 1 ) / 52.;
                var daily = {
                    date: day.getTime(),
                    year: day.getFullYear(),
                    month: day.getMonth(), // 0 - 11
                    day: day.getDate(), // 1 - 31
                    values: [
                        { label: 'emotions', value: Math.random() * multiplier },
                        { label: 'mind', value: Math.random() * multiplier },
                        { label: 'body', value: Math.random() * multiplier },
                        { label: 'life', value: Math.random() * multiplier },
                        { label: 'relationships', value: Math.random() * multiplier },
                    ],
                    notes: [],
                    images: []
                }
                if ( i > 0 ) {
                    var nImages = Math.random() * 4;
                    for ( var j = 0; j < nImages; j++ ) {
                        daily.images.push( { image: "icons/image.png" });
                    }
                    var nNotes = Math.random() * 4;
                    for ( j = 0; j < nNotes; j++ ) {
                        daily.notes.push( {title:"",note:""} );
                    }
                }
                Database.insert(dailyModel.table,daily);
            }
            //
            // challenge test data
            //
            var challengeData  = [
                        {
                            name: "Lying Back Excercise",
                            activity: "Lie on your back with both of your legs straight. In this position, bring your left knee up close to your chest. Hold this position for 10 seconds. Return your leg to the straight position. Repeat with the right leg.",
                            repeats: 5,
                            frequency: "morning and evening"
                        },
                        {
                            name: "Standing Back Excercise",
                            activity: "Stand up with your arms on your side. Bend to the left side while slowly sliding your left hand down your left leg. Come back up slowly and relax. Repeat with the right side of your body.",
                            repeats: 10,
                            frequency: "daily"
                        },
                        {
                            name: "Neck stretch up",
                            activity: "Keep your eyes centred on one object directly in front of you, now slowly move your head back. You will now be looking at the roof. Keep your whole body still. Hold this position for 5 seconds and slowly return your head to the start position.",
                            repeats: 3,
                            frequency: "hourly"
                        },
                        {
                            name: "Foot writing",
                            activity: "Barefooot write digits 1 to 10 using your toes raised up in the air.",
                            repeats: 1,
                            frequency: "weekly"
                        },

                    ];
            challengeData.forEach(function(challengeDatum) {
                challengeDatum.count = 0;
                challengeDatum.date = Date.now();
                Database.insert(challengeModel.table,challengeDatum);
            });
            Database.save();

        }
        //
        //
        //
        Database.load();
        //register.open();
        //
        //
        //
        //
        //
        //
        stack.push("qrc:///Dashboard.qml");
    }
    Connections {
        target: SystemUtils

    }

    Connections {
        target: Database
        onSuccess: {
            //console.log( 'database success : ' + collection + ' : ' + operation + ' : ' + JSON.stringify(result) );
            models.forEach( function( model ) {
                if ( model.table === collection ) {
                    model.databaseSuccess(collection,operation,result);
                }
            });
         }
        onError: {
            //console.log( 'database error : ' + collection + ' : ' + operation + ' : ' + JSON.stringify(error) );
            models.forEach( function( model ) {
                if ( model.table === collection ) {
                    model.databaseError(collection,operation,error);
                }
            });
        }
        property var models: [ dailyModel, challengeModel ];
    }

}
