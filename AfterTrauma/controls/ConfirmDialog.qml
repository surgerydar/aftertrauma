import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Popup {
    id: container
    //
    //
    //
    background: Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        opacity: .5
    }
    //
    //
    //
    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 32
        padding: 32
        Text {
            id: prompt
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            width: container.width - 32
            wrapMode: Text.WordWrap
            font.weight: Font.Bold
            font.family: fonts.light
            font.pixelSize: 24
            color: Colours.darkSlate
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            Repeater {
                model: _buttons
                //
                //
                //
                Item {
                    height: 48
                    width: label.contentWidth + 16
                    Background {
                        anchors.fill: parent
                        fill: Colours.darkSlate
                        opacity: .25
                    }
                    Text {
                        id: label
                        anchors.fill: parent
                        font.family: fonts.light
                        font.weight: Font.Bold
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: Colours.almostWhite
                        text: _buttons[ index ].label
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            _buttons[ index ].action();
                            container.close();
                        }
                    }
                }
            }
        }
    }

    onClosed: {
        _buttons = [{label:"Ok", action: function() { container.close(); } }];
    }

    function show( text, buttons ) {
        prompt.text = text;
        if ( buttons ) {
            _buttons = buttons;
        }
        open();
    }
    property var _buttons: [{label:"Ok", action: function() { container.close(); } }]
}
