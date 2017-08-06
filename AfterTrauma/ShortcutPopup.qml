import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    x: 0
    y: 0
    width: appWindow.width
    height: appWindow.height
    //
    //
    //
    background:Rectangle {
        anchors.fill: parent
        color: Colours.veryDarkSlate
        opacity: 0.5
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            close();
        }
    }
    //
    //
    //
    ListView {
        id: optionList
        //
        //
        //
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 8
        verticalLayoutDirection: ListView.BottomToTop
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: AfterTrauma.Button {
            height: 64
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            direction: "Right"
            textHorizontalAlignment: Text.AlignHCenter
            textVerticalAlignment: Text.AlignVCenter
            textColour: Colours.almostWhite
            textSize: 32
            backgroundColour: Colours.veryDarkSlate

            //
            //
            //
            text: model.title || ""
            image: model.image || ""
            //
            //
            //
            onClicked: {

                stack.push("qrc:///"+model.destination,model.options);
                close();
            }
        }
    }
    //
    //
    //
    function setOptions( options ) {
        optionList.model.clear();
        options.reverse();
        options.forEach( function(option) {
            optionList.model.append(option);
        });
    }
}
