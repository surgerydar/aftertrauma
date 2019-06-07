import QtQuick 2.7

import "controls" as AfterTrauma
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
   Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Colours.blue }
            GradientStop { position: 1.0; color: Colours.lightGreen }
        }
    }
   //
   //
   //
   AfterTrauma.BusyIndicator {
       id: busy
       anchors.centerIn: parent
   }
   //
   //
   //
   Text {
       anchors.top: busy.bottom
       anchors.horizontalCenter: parent.horizontalCenter
       anchors.topMargin: 16
       font.family: fonts.light
       font.pixelSize: 18
       color: Colours.almostWhite
       text: "Installing..."
   }
}
