import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

PageIndicator {
    id: control
    delegate: Rectangle {
        implicitWidth: 8
        implicitHeight: 8

        radius: width / 2
        color: Colours.darkOrange

        opacity: index === control.currentIndex ? 0.95 : 0.45

        Behavior on opacity {
            OpacityAnimator {
                duration: 100
            }
        }
    }
}
