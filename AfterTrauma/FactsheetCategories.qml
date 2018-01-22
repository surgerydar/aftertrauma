import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container

    title: "RESOURCES"
    colour: Colours.darkOrange
    //
    //
    //
    ListView {
        id: categories
        //
        //
        //
        height: Math.min( parent.height, contentHeight )
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 16
        //
        //
        //
        interactive: contentHeight >= parent.height
        clip: true
        spacing: 4
        //
        //
        //
        model: categoryModel//ListModel {}
        //
        //
        //
        delegate: FactsheetItem {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            textSize: 48
            text: model.title || ""
            backgroundColour: Colours.categoryColour(model.index)
            radius: model.index === 0 ? [8,8,0,0] : model.index === categories.model.count - 1 ? [0,0,8,8] : [0]
            onClicked: {
                stack.push( "qrc:///FactsheetCategory.qml", { title: model.title, colour: Colours.categoryColour(model.index), category: model.category });
            }
        }
        //
        //
        //
        add: Transition {
            NumberAnimation { properties: "y"; from: categories.height; duration: 250 }
        }
    }

    StackView.onActivating:  {
        //
        // initialisation
        //
        categoryModel.setFilter( { section : "resources" } );
    }
}
