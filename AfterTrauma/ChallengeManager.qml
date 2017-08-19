import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

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
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        footer: Component {
            Item {
                height: 64
                anchors.left: parent.left
                anchors.right: parent.right
                /*
                //
                //
                //
                AfterTrauma.Background {
                    anchors.fill: parent
                    anchors.margins: 4
                    fill: Colours.lightGreen
                }
                */
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
        }
        //
        //
        //
        model: challengeModel
        //
        //
        //
        delegate: ChallengeManagerItem {
            anchors.left: parent.left
            anchors.right: parent.right
            name: model.name
            activity: model.activity
            count: model.count || 0
            onCountChanged: {
                challengeModel.updateCount( model.index, count );
            }
            onClicked: {
                stack.push( "qrc:///ChallengeBuilder.qml", {source: challengeModel.get(index)});
            }
            onRemove: {
                challengeModel.remove({_id:challengeModel.get(index)._id});
            }
        }
        add: Transition {
            NumberAnimation { properties: "y"; from: challenges.height; duration: 250 }
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
        //challenges.update();
    }
    //
    //
    //
    Connections {
        target: challengeModel
        onDataChanged: {
            console.log( 'challengeModel.onDataChanged');
            challenges.forceLayout();
        }
    }
}
