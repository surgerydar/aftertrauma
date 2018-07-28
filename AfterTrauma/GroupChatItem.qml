import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.EditableListItem {
    id: container
    //
    //
    //
    height: 64
    //contentEditable: owner === userProfile.id

    contentItem: Item {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //
        //
        //
        AfterTrauma.Background {
            anchors.fill: parent
            fill: Colours.darkPurple
        }
        //
        //
        //
        Image {
            id: avatarImage
            width: height
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 4
            //
            //
            //
            fillMode: Image.PreserveAspectFit
            //
            //
            //
            source: "icons/profile_icon.png"
            //
            //
            //
            onStatusChanged: {
                if ( status === Image.Error ) {
                    console.log( 'error loading avatar icon : ' + source );
                    source = "icons/profile_icon.png";
                }
            }
            //
            //
            //
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //stack.push( "qrc:///ProfileViewer.qml", { userId: owner } );
                    profileViewer.open( owner );
                }
            }
        }
        //
        //
        //
        Text {
            id: subjectText
            anchors.top: parent.top
            anchors.left: avatarImage.right
            anchors.bottom: parent.verticalCenter
            anchors.right: chatButton.left
            anchors.margins: 8
            anchors.bottomMargin: 4
            //
            //
            //
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 32
            minimumPointSize: 16
            fontSizeMode: Text.Fit
            elide: Text.ElideRight
            color: Colours.almostWhite
            //
            //
            //
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
        }
        //
        //
        //
        ListView {
            id: memberList
            anchors.top: parent.verticalCenter
            anchors.left: avatarImage.right
            anchors.leftMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            anchors.right: chatButton.left
            anchors.rightMargin: 8
            //
            //
            //
            interactive: count * height > width
            clip: true
            orientation: ListView.Horizontal
            //
            //
            //
            delegate: Image {
                height: memberList.height
                width: height
                fillMode: Image.PreserveAspectCrop
                source: "https://aftertrauma.uk:4000/avatar/" + model.modelData
                //
                //
                //
                onStatusChanged: {
                    if ( status === Image.Error ) {
                        console.log( 'error loading avatar icon : ' + source );
                        source = "icons/profile_icon.png";
                    }
                }
            }
        }
        //
        //
        //
        AfterTrauma.Button {
            id: chatButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 16
            image: "icons/chat.png"
            onClicked: {
                chat();
            }
        }
        //
        //
        //
        NumberBadge {
            id: count
            height: chatButton.height / 2
            anchors.top: chatButton.top
            anchors.right: chatButton.right
        }
        //
        //
        //
        /*
        MouseArea {
            anchors.fill: parent
            onClicked: {
                chat();
            }
        }
        */
    }
    //
    //
    //
    signal chat()
    //
    //
    //
    property alias avatar: avatarImage.source
    property alias subject: subjectText.text
    property string owner: ""
    property alias members: memberList.model
    property alias count: count.text
}
