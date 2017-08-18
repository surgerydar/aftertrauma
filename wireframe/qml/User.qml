Item {
    width: parent.width
    height: 96
    //
    //
    //
    property var index: #index
    property var itemId: "#id"
    //
    //
    //
    Rectangle {
        id: background#index
        antialiasing: true
        anchors.fill: parent
        color: parent.index % 2 ? "lightGrey" : "white"
    }
    Image {
        id: profileImage#index
        width: 48
        height: 48
        anchors.top: parent.top
        anchors.left: parent.left
        fillMode: Image.PreserveAspectFit
        source: "icons/user-black.png"
    }
    Label {
        id: headerLabel#index
        height: 32
        anchors.top: parent.top
        anchors.left: profileImage#index.right
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Bold
        font.pixelSize: 24
        elide: Text.ElideRight
        text: "#username"
    }
    Text {
        id: summarylabel#index
        anchors.top: headerLabel#index.bottom
        anchors.left: profileImage#index.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Light
        font.pixelSize: 24
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        text: "#profile"
    }
}
