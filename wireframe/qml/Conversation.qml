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
    property var fromId: "#fromid"
    property var toId: "#toid"
    property var fromUsername: "#fromusername"
    property var toUsername: "#tousername"
    property var title: "#title"
    property var privacy: "#privacy"
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
        id: userLabel#index
        height: 16
        anchors.top: parent.top
        anchors.left: profileImage#index.right
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Light
        font.pixelSize: 12
        text: userId === parent.fromId ? parent.toUsername : parent.fromUsername
    }
    Label {
        id: headerLabel#index
        height: 32
        anchors.top: userLabel#index.bottom
        anchors.left: profileImage#index.right
        anchors.right: parent.right
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: Label.AlignLeft
        font.weight: Font.Bold
        font.pixelSize: 24
        elide: Text.ElideRight
        text: "#title"
    }
}
