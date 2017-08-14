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
    }
    //
    // global models
    //
    Daily {
        id: dailyModel
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
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.verticalCenter
        anchors.right: parent.right
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
                        daily.images.push( { title: "image", image: "icons/image.png" });
                    }
                    var nNotes = Math.random() * 4;
                    for ( j = 0; j < nImages; j++ ) {
                        daily.notes.push( { title: "note", note: "random note" + j });
                    }
                }
                Database.insert('daily',daily);
            }
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
            dailyModel.databaseSuccess(collection,operation,result);
        }
        onError: {
            //console.log( 'database error : ' + collection + ' : ' + operation + ' : ' + JSON.stringify(error) );
            dailyModel.databaseError(collection,operation,error);
        }

    }

}
