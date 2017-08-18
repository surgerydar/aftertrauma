Item {
    width: parent.width
    height: ( userLabel#index.height + contentText#index.height ) + 32
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
    //
    //
    //
    Rectangle {
        id: background#index
        antialiasing: true
        anchors.fill: parent
        anchors.topMargin: 2
        anchors.leftMargin: userId === parent.fromId ? 0 : 48
        anchors.bottomMargin: 2
        anchors.rightMargin: userId === parent.fromId ? 48 : 0
        color: "lightGrey"
    }
    Image {
        id: profileImage#index
        width: 48
        height: 48
        anchors.top: parent.top
        anchors.left: userId === parent.fromId ? parent.left : undefined
        anchors.right: userId === parent.fromId ? undefined : parent.right
        fillMode: Image.PreserveAspectFit
        source: "icons/user-black.png"
    }
    Label {
        id: userLabel#index
        height: 16
        anchors.top: parent.top
        anchors.left: userId === parent.fromId ? profileImage#index.right : background#index.left
        anchors.right: userId === parent.fromId ? background#index.right : profileImage#index.left
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: userId === parent.fromId ? Label.AlignLeft : Label.AlignRight
        font.weight: Font.Light
        font.pixelSize: 12
        text: "#fromusername"
    }
    Text {
        id: contentText#index
        anchors.top: userLabel#index.bottom
        anchors.left: userId === parent.fromId ? profileImage#index.right : background#index.left
        anchors.right: userId === parent.fromId ? background#index.right : profileImage#index.left
        anchors.margins: 8
        verticalAlignment: Label.AlignTop
        horizontalAlignment: userId === parent.fromId ? Label.AlignLeft : Label.AlignRight
        font.pixelSize: 18
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        text: "#content"
    }
}
