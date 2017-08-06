import QtQuick 2.6
import QtQuick.Controls 2.1

Item {
    FontLoader {
        id: regularFont
        source: "../fonts/Roboto-Regular.ttf"
    }
    FontLoader {
        id: lightFont
        source: "../fonts/Roboto-Light.ttf"
    }
    FontLoader {
        id: boldFont
        source: "../fonts/Roboto-Bold.ttf"
    }
    /*
    //
    //
    //
    Text {
        id: regularTest
        height: 48
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        font.family: regular
        font.pixelSize: 32
        text: regular + ' Regular'
    }
    Text {
        id: lightTest
        height: 48
        anchors.top: regularTest.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        font.family: light
        font.pixelSize: 32
        text: light + ' Light'
    }
    Text {
        id: boldTest
        height: 48
        anchors.top: lightTest.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        font.family: bold
        font.pixelSize: 32
        text: bold + ' Bold'
    }
    */
    property alias regular: regularFont.name
    property alias light: lightFont.name
    property alias bold: boldFont.name
}
