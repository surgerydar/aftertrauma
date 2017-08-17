import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0

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
        }
        //register.open();
        //
        //
        //
        //
        //
        //
        stack.push("qrc:///Dashboard.qml");
    }
    //
    //
    //
    Connections {
        target: SystemUtils

    }
    //
    // TODO: look at best way to move this into separate component or just let models connect directly ( possibly wastefull )
    // UPDATE: now removing this replacing with DatabaseList
    //
    Connections {
        target: Database
        onSuccess: {
            //console.log( 'database success : ' + collection + ' : ' + operation + ' : ' + JSON.stringify(result) );
            models.forEach( function( model ) {
                if ( model.collection === collection ) {
                    model.databaseSuccess(collection,operation,result);
                }
            });
         }
        onError: {
            //console.log( 'database error : ' + collection + ' : ' + operation + ' : ' + JSON.stringify(error) );
            models.forEach( function( model ) {
                if ( model.collection === collection ) {
                    model.databaseError(collection,operation,error);
                }
            });
        }
        property var models: [ dailyModel, challengeModel ];
    }
    //
    // global properties
    //
    property bool loggedIn: false
}
