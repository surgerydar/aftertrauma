import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

BusyIndicator {
    id: control
    anchors.fill: parent
    contentItem: Item {
        anchors.fill: control
        visible: running
        //
        //
        //
        Rectangle {
            anchors.fill: parent
            color: Colours.veryDarkSlate
            opacity: .5
        }
        //
        //
        //
        Item {
            id: item
            anchors.centerIn: parent
            width: 64
            height: 64
            opacity: control.running ? 1 : 0
            //
            //
            //
            Behavior on opacity {
                OpacityAnimator {
                    duration: 250
                }
            }
            //
            //
            //
            RotationAnimator {
                target: item
                running: control.visible && control.running
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1250
            }
            //
            //
            //
            Repeater {
                id: repeater
                model: 6
                //
                //
                //
                Rectangle {
                    x: item.width / 2 - width / 2
                    y: item.height / 2 - height / 2
                    implicitWidth: 10
                    implicitHeight: 10
                    radius: 5
                    color: Colours.almostWhite
                    transform: [
                        Translate {
                            y: -Math.min(item.width, item.height) * 0.5 + 5
                        },
                        Rotation {
                            angle: index / repeater.count * 360
                            origin.x: 5
                            origin.y: 5
                        }
                    ]
                }
            }
        }
        //
        //
        //
        Label {
            id: prompt
            anchors.top: item.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            color: Colours.almostWhite
            font.family:  fonts.light
            font.pointSize: 18
            wrapMode: Label.Wrap
            horizontalAlignment: Label.AlignHCenter
        }
        //
        //
        //
        MouseArea {
            anchors.fill: parent
            enabled: running
            onClicked: {
                console.log( 'sorry dave I am busy' );
            }
        }
    }
    //
    //
    //
    onRunningChanged: {
        if ( !running ) {
            prompt.text = "";
        }
    }
    //
    //
    //
    function show( text ) {
        control.prompt = text;
        running = true;
    }
    function hide() {
        running = false;
    }

    property alias prompt: prompt.text
}
