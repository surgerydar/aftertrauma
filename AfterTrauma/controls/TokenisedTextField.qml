import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

TextField {
    id: container
    height: 48
    color: Colours.veryDarkSlate
    font.pixelSize: 24
    echoMode: TextInput.NoEcho
    //
    //
    //
    cursorDelegate: Item {
        width: Math.max(2,tagContainer.childrenRect.width - x)
        height: container.height
        Rectangle {
            anchors.right: parent.right
            width: 2
            height: parent.height - 4
            anchors.verticalCenter: parent.verticalCenter
            color: Colours.darkSlate
            visible: testInput.focus
            PropertyAnimation on opacity {
                duration: 500
                loops: Animation.Infinite
                from: 0.
                to: 1.
            }
        }
    }
    //
    //
    //
    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: 4
        color: Colours.veryLightSlate
        border.color: "transparent"
        Row {
            id: tagContainer
            anchors.fill: parent
            leftPadding: 8
            rightPadding: 8
            spacing: 4
            Repeater {
                model: container.tokenised.length
                Rectangle {
                    height: parent.height - 4
                    width: childrenRect.width + 8
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 4
                    color: 'lightgray'
                    Text {
                        x: 4
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font: container.font
                        text: testInput.tokenised[ index ]
                    }
                }
            }
        }
    }
    //
    //
    //
    onTextChanged: {
        var tags = text.split(delimiter);
        var display = [];
        tags.forEach(function(tag){
            display.push( tag.trim().toLowerCase() );
        });
        tokenised = display;
    }
    //
    //
    //
    property string delimiter: ','
    property var    tokenised: []
    property alias  backgroundColour: background.color
}
