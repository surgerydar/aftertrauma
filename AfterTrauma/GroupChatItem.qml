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
            anchors.margins: 8
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
        }
        //
        //
        //
        Text {
            id: subjectText
            anchors.top: parent.top
            anchors.left: avatarImage.right
            //anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 8
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
        Text {
            id: activityText
            anchors.top: subjectText.top
            anchors.left: avatarImage.right
            //anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 8
            //
            //
            //
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 16
            minimumPointSize: 12
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
        MouseArea {
            anchors.fill: parent
            enabled: container.status === "active"
            onClicked: {
                chat();
            }
        }
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
    property alias activity: activityText.text
    property string owner: ""
    property var members: []
}
