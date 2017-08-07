Item {
    width: parent.width
    height: 96
    //
    //
    //
    property var index: #index
    property var itemId: "#id"
    property var userId: "#userId"
    //
    //
    //
    property var owner: "#owner"
    property var name: "#name"
    property var description: "#description"
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
        id: nameLabel#index
        height: 16
        anchors.top: parent.top
        anchors.left: profileImage#index.right
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Bold
        font.pixelSize: 18
        text: "#name"
    }
    Text {
        id: descriptionText#index
        height: 32
        anchors.top: nameLabel#index.bottom
        anchors.left: profileImage#index.right
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.Light
        font.pixelSize: 18
        elide: Text.ElideRight
        text: "#description"
    }
}
