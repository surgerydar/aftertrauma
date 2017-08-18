Item {
    width: parent.width
    height: ( dateLabel#index.height + headerLabel#index.height + contentlabel#index.height ) + 32
    //
    //
    //
    property var index: #index
    property var userId: "#userId"
    property var itemId: "#id"
    property var date: #date
    property string month: new Date( #date ).toDateString().split(' ')[ 1 ]
    //
    //
    //
    Rectangle {
        id: background#index
        antialiasing: true
        anchors.fill: parent
        color: parent.index % 2 ? "lightGrey" : "white"
    }
    Label {
        id: dateLabel#index
        height: 16
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Light
        font.pixelSize: 12
        text: new Date( #date ).toDateString()
    }
    Label {
        id: headerLabel#index
        height: 32
        anchors.top: dateLabel#index.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Bold
        font.pixelSize: 24
        elide: Text.ElideRight
        text: "#title"
    }
    Text {
        id: contentlabel#index
        anchors.top: headerLabel#index.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.Light
        font.pixelSize: 24
        wrapMode: Text.WordWrap
        //elide: Text.ElideRight
        text: "#content"
    }
}
