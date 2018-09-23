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
    title: "CHALLENGES"
    colour: Colours.lightGreen
    //
    //
    //
    ListView {
        id: challenges
        anchors.fill: parent
        anchors.bottomMargin: 4
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: challengeModel
        //
        //
        //
        section.property: "active"
        section.delegate: Text {
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 32
            font.capitalization: Font.Capitalize
            color: Colours.almostWhite
            text:  ( section === "true" ? "Active" : "Inactive" )
        }
        //
        //
        //
        delegate: ChallengeManagerItem {
            width: challenges.width
            name: model.name
            activity: model.activity
            swipeEnabled: editable
            active: model.active
            done: model.count >= parseInt( model.repeats ) || false
            onDoneChanged: {
                challengeModel.updateCount( model.index, done ? model.repeats : 0 );
                var challenge = {
                    _id: model._id,
                    name: model.name
                };
                var date = new Date();
                if ( done ) {
                    dailyModel.addChallenge( date, challenge );
                } else {
                    dailyModel.removeChallenge( date, challenge );
                }
            }

            onEdit: {
                stack.push( "qrc:///ChallengeBuilder.qml", {source: challengeModel.get(index)});
            }
            onRemove: {
                challengeModel.remove({_id:challengeModel.get(index)._id});
            }
            onClicked: {
                if ( !editable ) {
                    var properties = {
                        title: model.name,
                        activity: Utils.formatChallengeDescription(model.activity, model.repeats, model.frequency),
                        active: model.active,
                        notifications: model.notifications,
                        challengeId: challengeModel.get(index)._id
                    };
                    stack.push( "qrc:///ChallengeViewer.qml", properties );
                }
            }
        }
        add: Transition {
            NumberAnimation { properties: "y"; from: challenges.height; duration: 250 }
        }
    }
    //
    //
    //
    footer: Rectangle {
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        color: Colours.lightGreen
        //
        //
        //
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: editable ? "done" : "edit"
            onClicked: {
                editable = !editable;
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            id: addButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            image: "icons/add.png"
            backgroundColour: "transparent"
            //
            //
            //
            onClicked: {
                stack.push( "qrc:///ChallengeBuilder.qml")
            }
        }
    }
    //
    //
    //
    /*
    AfterTrauma.Button {
        id: addButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: -64
        image: "icons/add.png"
        backgroundColour: "transparent"
        //
        //
        //
        onClicked: {
            stack.push( "qrc:///ChallengeBuilder.qml")
        }
    }
    */
    //
    //
    //
    //
    //
    //
    StackView.onActivated: {
        //challengeModel.load();
        //editable = false;
    }
    function formatDescription( activity, repeats, frequency ) {
        return activity + '<p>' + 'repeat ' + repeats + ' time' + ( repeats > 1 ? 's ' : ' ' ) + ', ' + frequency;
    }

    //
    //
    //
    /*
    Connections {
        target: challengeModel
        onDataChanged: {
            console.log( 'challengeModel.onDataChanged');
            challenges.forceLayout();
        }
    }
    */
    //
    //
    //
    property bool editable: false
}
