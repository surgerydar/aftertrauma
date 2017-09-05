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
    /* TODO:
    Settings {
        id: settingsModel
    }
    */
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
    Chats {
        id: chatModel
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
        enabled: false
    }
    //
    //
    //
    StackView {
        id: stack
        anchors.fill: parent
        anchors.topMargin: titleBar.height
        //anchors.bottomMargin: 28
        //
        //
        //
        function navigateTo( qmlSource, properties ) {
            var item = find(function(current) {
                //console.log( 'item url:' + current);
                return current.qmlSource === qmlSource;
            });

            if ( item ) {
                pop(item);
            } else {
                item = push(qmlSource, properties);
                if ( item && item.qmlSource !== undefined ) {
                    item.qmlSource = qmlSource;
                }
            }

        }
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
    AfterTrauma.BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 2
        text: "(" + parent.width + "," + parent.height + ")"
    }

    //
    //
    //
    Component.onCompleted: {
        //
        // TODO: check settings for first use
        //
        if ( SystemUtils.isFirstRun() ) {
            console.log( 'installing' );
            //stack.push("qrc:///Install.qml")
            SystemUtils.install();

            intro.open();
        } else {
            //
            //
            //
            stack.push("qrc:///Dashboard.qml");
            flowerChart.enabled = true;
        }
    }
    //
    //
    //
    Connections {
        target: SystemUtils
        //
        //
        //
        onInstallComplete: {
            stack.push("qrc:///Dashboard.qml");
            flowerChart.enabled = true;
        }

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
    function testUser() {
        return { id:"{5f9ba729-6a16-48c6-81a2-2de6d3db69ca}", username: "justTestin" };
    }
    //
    // global properties
    //
    property bool loggedIn: false
    property var userProfile: null //testUser()
    property string baseURL: "https://aftertrauma.uk:4000"
    property string baseWS: "wss://aftertrauma.uk:4000"
}
