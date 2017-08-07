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
        onDateRangeChanged: {
            /* TODO: remove this
            dateSlider.startDate = startDate;//new Date(startDate);
            dateSlider.endDate = endDate; //new Date(endDate);
            dateSlider.updateDisplay(dateSlider.value);
            console.log( 'FlowerChart.onDateRangeChanged - startDate:' + startDate + ' endDate:' + endDate );
            */
        }
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
            SystemUtils.install();
        }
        //register.open();

        Database.load();
        stack.push("qrc:///Dashboard.qml");



    }
    Connections {
        target: SystemUtils

    }

    //
    //
    //
    AfterTrauma.Fonts {
        id: fonts
    }
}
