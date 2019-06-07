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
        width: Math.max(0,tagContainer.childrenRect.width - x)+2
        height: container.height
        anchors.verticalCenter: container.verticalCenter
        Rectangle {
            anchors.right: parent.right
            width: 2
            height: parent.height - 4
            anchors.verticalCenter: parent.verticalCenter
            color: Colours.darkSlate
            visible: container.focus
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
                        text: container.tokenised[ index ]
                    }
                }
            }
        }
    }
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
        visible: model.count > 0
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
    onFocusChanged: {
        if ( focus ) {
            cursorPosition = length;
        } else {
            suggestionList.model.clear();
        }
    }
    onTextChanged: {
        tokenise();
        suggest();
    }
    onAccepted: {
        if ( suggest() ) {
            commitTag(suggestions[ 0 ].tag);
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
    function suggest() {
        suggestionList.model.clear();
        if ( tokenised.length > 0 ) {
            var tag = tokenised[ tokenised.length-1 ];
            //suggestions = tagsModel.find({ tag: { "$startswith" : tag } } );
            suggestions = tagsModel.find({ tag: new RegExp( '^' + tag + '[a-z,0-9]*' ) } );
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
        console.log('tokenised : ' + JSON.stringify(tokenised) );
    }

    //
    //
    //
    property string delimiter: '|'
    property var    tokenised: []
    property var    suggestions: []
    property alias  backgroundColour: background.color
}
