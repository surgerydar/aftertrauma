import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Rectangle {
    id: container
    height: 48
    radius: 4
    color: Colours.almostWhite
    //
    //
    //
    ListView {
        id: tagList
        anchors.fill: parent
        orientation: ListView.Horizontal
        spacing: 4
        clip: true
        //
        //
        //
        delegate: Rectangle {
            height: parent.height
            width: childrenRect.width + 8
            anchors.verticalCenter: parent.verticalCenter
            //
            //
            //
            TextInput {
                id: input
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                text: model.tag
                onTextChanged: {
                    suggest(text);
                }
                //
                //
                //
                onAccepted: {
                    if ( suggest() ) {
                        commitTag(suggestions[ 0 ].tag);
                    }
                }
            }
            //
            //
            //
            Image {
                width: parent.height - 4
                height: parent.height - 4
                anchors.left: input.left
                anchors.leftMargin: 2
                source: "icons/close_circle.png"
                //
                //
                //
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        tagList.model.remove(model.index)
                    }
                }
            }
        }
    }
    /*
    //
    //
    //
    ListView {
        id: suggestionList
        width: container.width - 4
        anchors.top: container.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: container.top
        anchors.topMargin: -208;
        anchors.bottomMargin: 4;
        spacing: 4
        verticalLayoutDirection: ListView.BottomToTop
        model: ListModel {}
        delegate: Rectangle {
            height: 48
            width: container.width
            radius: 4
            color: Colours.almostWhite
            opacity: .9
            Text {
                anchors.fill: parent
                anchors.margins: 4
                font: container.font
                color: Colours.lightSlate
                verticalAlignment: Text.AlignVCenter
                text: model.text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    commitTag(model.text);
                }
            }
        }
    }
    //
    //
    //
    function tokenise() {
        var tags = text.split(delimiter);
        var display = [];
        tags.forEach(function(tag){
            var trimmed = tag.trim().toLowerCase();
            if ( trimmed.length > 0 ) {
                display.push( trimmed );
            }
        });
        //
        // remove duplicates
        //
        for ( var i = display.length - 1; i >= 0; i-- ) {
            if ( display.indexOf(display[i]) < i ) {
                display = display.splice(i,1);
            }
        }
        tokenised = display;
    }
    function suggest(tag) {
        suggestionList.model.clear();
        if ( tag.length > 0 ) {
            suggestions = tagsModel.find({ tag: { "$startswith" : tag } } );
            suggestions.sort( function( a, b) {
                if ( a.tag.length > b.tag.length ) return 1;
                if ( a.tag.length < b.tag.length ) return -1;
                return 0;
            });
            suggestions.forEach( function( suggestion ) {
                suggestionList.model.append({text: suggestion.tag});
            });
            return suggestions.length > 0;
        }
        return false;
    }
    function commitTag( tag ) {
        tokenised[tokenised.length-1] = tag;
        text = tokenised.join(delimiter) + delimiter;
        tokenise();
        suggestionList.model.clear();
    }

    //
    //
    //
    property string delimiter: '|'
    property var    tokenised: []
    property var    suggestions: []
    property alias  backgroundColour: background.color
    */
}
