import QtQuick 2.6
import QtQuick.Controls 2.1

Item {
    FontLoader {
        id: regularFont
        source: "../fonts/Roboto-Regular.ttf"
        onStatusChanged: {
            if (status == FontLoader.Ready) {
                console.log('regularFont ready : name' + regularFont.name );
            } else if (status == FontLoader.Error ) {
                console.log('regularFont error' );
            }
        }
    }
    FontLoader {
        id: lightFont
        source: "../fonts/Roboto-Light.ttf"
        onStatusChanged: {
            if (status == FontLoader.Ready) {
                console.log('lightFont ready : name' + lightFont.name );
            } else if (status == FontLoader.Error ) {
                console.log('regularFont error'  );
            }
        }
    }
    FontLoader {
        id: boldFont
        source: "../fonts/Roboto-Bold.ttf"
        onStatusChanged: {
            if (status == FontLoader.Ready) {
                console.log('boldFont ready : name' + boldFont.name );
            } else if (status == FontLoader.Error ) {
                console.log('boldFont error' );
            }
        }
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
        font.weight: Font.Normal
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
        font.weight: Font.Light
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
        font.weight: Font.Bold
        text: bold + ' Bold'
    }
    */
    property alias regularFont: regularFont
    property alias lightFont: lightFont
    property alias boldFont: boldFont
    property alias regular: regularFont.name
    property alias light: lightFont.name
    property alias bold: boldFont.name
}
