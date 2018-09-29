import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours
import "styles.js" as Styles

Item {
    id: container
    //
    //
    //
    height: Math.max( 64, messageText.contentHeight + 24 )
    //
    //
    //
    Image {
        id: avatarImage
        width: 48
        height: width
        anchors.top: parent.top
        anchors.left: from === userProfile.id ? parent.left : undefined
        anchors.right: from === userProfile.id ? undefined : parent.right
        fillMode: Image.PreserveAspectFit
        source: baseURL + "/avatar/" + from + '?width=56&height=56'
        onStatusChanged: {
            if ( status === Image.Error ) {
                source = "icons/profile_icon.png";
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                profileViewer.open( from );
            }
        }
    }
    //
    //
    //
    Item {
        anchors.fill: parent
        anchors.leftMargin: from === userProfile.id ? 56 : 0
        anchors.rightMargin: from === userProfile.id ? 0 : 56
        //
        //
        //
        AfterTrauma.Background {
            anchors.fill: parent
            radius: [8]
            fill: Colours.almostWhite
        }
        //
        //
        //
        Text {
            id: messageText
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 16
            anchors.rightMargin: 8
            color: Colours.veryDarkSlate
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.family: fonts.light
            font.pointSize: 18
            //
            //
            //
            onLinkActivated: {
                processLink(link);
            }
            onTextChanged: {
                messageText.text = Styles.style(text,"global");
            }
        }
        //
        //
        //
        Text {
            id: dateText
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 8
            anchors.bottomMargin: 4
            color: Colours.veryDarkSlate
            font.weight: Font.Light
            font.family: fonts.light
            font.pointSize: 10
        }
    }
    //
    //
    //
    property alias message: messageText.text
    property alias date: dateText.text
    property string from: ""
}
