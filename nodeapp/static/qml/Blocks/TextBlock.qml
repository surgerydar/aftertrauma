import QtQuick 2.7

Text {
    id: container
    width: parent.width
    height: contentHeight
    wrapMode: Text.WordWrap
    //
    //
    //
    property alias media: container.text
    //
    //
    //
    onLinkActivated: {
        //
        //
        //
        ListView.view.linkActivated( link );
    }
}
