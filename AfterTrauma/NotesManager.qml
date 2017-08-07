import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "NOTES"
    colour: Colours.blue
    //
    //
    //
    ListView {
        id: notes
        anchors.fill: parent
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: NoteItem {
            anchors.left: parent.left
            anchors.right: parent.right
            note: model.note
            date: container.date
        }
    }
    //
    //
    //
    footer: Item {
        id: toolbar
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        AfterTrauma.Button {
            id: addNote
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 8
            anchors.bottomMargin: 64

            backgroundColour: colour
            image: "icons/add.png"
            text: "add note"
            //
            //
            //
            onClicked: {
                stack.push( "qrc:///NoteEditor.qml", { date: date } );
            }
        }
    }
    //
    //
    //
    onDateChanged: {
        subtitle = Utils.shortDate( date );
    }
    //
    //
    //
    StackView.onActivated: {
        //
        // TODO: get this from database
        //
        var data  = {
            date: Date.now(),
            notes:[
                { note: "A little note to myself, don't give up" },
                { note: "No really don't" },
                { note: "Feeling a bit better today though" }
            ]
        };
        date = data.date;
        notes.model.clear();
        data.notes.forEach(function(note) {
            notes.model.append(note);
        });
    }
    //
    //
    //
    property var date: Date.now()
}
