import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container

    title: "INFORMATION"
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
        //anchors.margins: 16
        //
        //
        //
        interactive: contentHeight >= parent.height
        clip: true
        spacing: 8
        //
        //
        //
        model: categoryModel
        //
        //
        //
        delegate: FactsheetItem {
            anchors.left: parent.left
            anchors.right: parent.right
            textSize: 24
            text: model.title || ""
            backgroundColour: Colours.categoryColour(model.index)
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
    //
    //
    //
    footer: Item {
        height: 16
    }
    //
    //
    //
    StackView.onActivating:  {
        //
        // initialisation
        //
        categoryModel.setFilter( { section : "resources" } );
    }
}
