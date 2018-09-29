import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Rectangle {
    id: container
    height: 64
    color: Colours.almostWhite
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
        //
        //
        //
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //stack.push( "qrc:///ProfileViewer.qml", { userId: userId } );
                profileViewer.open(userId);
            }
        }
    }
    //
    //
    //
    Text {
        id: usernameText
        height: 32
        anchors.top: parent.top
        anchors.left: avatarImage.right
        anchors.right: select.left
        anchors.bottom: parent.verticalCenter
        anchors.margins: 8
        //
        //
        //
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 18
        color: Colours.darkSlate
    }
    //
    //
    //
    Text {
        id: profileText
        anchors.top: parent.verticalCenter
        anchors.left: avatarImage.right
        anchors.bottom: parent.bottom
        anchors.right: select.left
        anchors.margins: 4
        //
        //
        //
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        font.weight: Font.Light
        font.family: fonts.light
        font.pixelSize: 12
        color: Colours.darkSlate
    }
    //
    //
    //
    AfterTrauma.CheckBox {
        id: select
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        text: "select"
    }
    //
    //
    //
    property string userId: ""
    property alias avatar: avatarImage.source
    property alias username: usernameText.text
    property alias profile: profileText.text
    property alias selected: select.checked
    property alias actionLabel: select.text
    property alias selectionEnabled: select.visible
}
