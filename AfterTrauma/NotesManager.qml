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
    subtitle: date > 0 ? Utils.shortDate(date) : ""
    colour: Colours.blue
    //
    //
    //
    SwipeView {
        id: notesView
        anchors.fill: parent
        anchors.bottomMargin: 36
        //
        //
        //
        Repeater {
            id: notesRepeater
            delegate: NotePage {
                note: notes[index].note
                onNoteChanged: {
                   notes[index].note = note;
                }
            }
        }
    }
    AfterTrauma.PageIndicator {
        anchors.horizontalCenter: notesView.horizontalCenter
        anchors.bottom: notesView.bottom
        anchors.bottomMargin: 16
        currentIndex: notesView.currentIndex
        count: notesView.count
        colour: Colours.lightSlate
    }
    AfterTrauma.Button {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        image: "icons/add.png"
        backgroundColour: "transparent"
        visible: notes.length >= 1 && notes[ notes.length -  1 ].note !== ""
        onClicked: {
            notes.push({title:"", note:""});
            notesRepeater.model = notes;
            notesView.currentIndex = notes.length - 1;
        }
    }
    //
    //
    //
    footer: Item {
        height: 28
    }
    //
    //
    //
    StackView.onActivated: {
        console.log( 'NotesManager : activating' );
        var day;
        if ( date === 0 ) {
            console.log( 'NotesManager : getting todays notes' );
            day = dailyModel.getTodayAsObject();
            date = day.date;
        } else {
            day = dailyModel.getDayAsObject(new Date(date));
        }
        notes = day.notes;
        if ( notes.length === 0 ) {
            console.log( 'NotesManager : no notes so creating default' );
            //
            // add default empty note
            //
            notes.push({name:"",note:""});
         }
         notesRepeater.model = notes;
    }
    StackView.onDeactivating: {
        var day = dailyModel.getDayAsObject(new Date(date));
        if ( day ) {
            day.notes = notes
            dailyModel.update(day);
        }
    }
    //
    //
    //
    property var notes: []
    property var date: 0
}
