import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

AfterTrauma.Page {
    id: container
    //
    //
    //
    title: "SETTINGS"
    colour: Colours.almostWhite
    //
    //
    //
    SwipeView {
        id: contents
        anchors.fill: parent
        Page {
            padding: 0
            title: "Settings"
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            //
            //
            //
            Flickable {
                id: settingsContainer
                anchors.fill: parent
                clip: true
                contentHeight: settingsItems.childrenRect.height + 16
                //
                //
                //
                Column {
                    id: settingsItems
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 4
                    //
                    //
                    //
                    Rectangle {
                        id: stayLoggedInBlock
                        width: settingsContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        AfterTrauma.CheckBox {
                            id: stayLoggedIn
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 8
                            text: "Stay logged in"
                            checked: profile && profile.stayLoggedIn
                            direction: "Right"
                            onCheckedChanged: {
                                profile.stayLoggedIn = checked;
                                dirty = true;
                            }
                        }
                    }
                    Rectangle {
                        id: changePasswordBlock
                        width: settingsContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        AfterTrauma.TextField {
                            id: currentPassword
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            echoMode: TextField.Password
                            placeholderText: "current password"
                        }
                        AfterTrauma.TextField {
                            id: newPassword
                            anchors.top: currentPassword.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            echoMode: TextField.Password
                            placeholderText: "new password"
                        }
                        AfterTrauma.Button {
                            anchors.top: newPassword.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: 8
                            backgroundColour: Colours.slate
                            textColour: Colours.almostWhite
                            text: "reset password"
                            onClicked: {
                                profileChannel.send({
                                                        command : 'changepassword',
                                                        token : profile.token,
                                                        username: profile.username,
                                                        oldpass : currentPassword.text,
                                                        newpass : newPassword.text
                                                    });
                            }
                        }
                    }
                    /*
                    Rectangle {
                        id: archiveBlock
                        width: settingsContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        AfterTrauma.Button {
                            id: archiveButton
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 8
                            backgroundColour: Colours.slate
                            textColour: Colours.almostWhite
                            text: "archive personal data"
                            onClicked: {
                                var source = SystemUtils.documentDirectory();
                                var archive = source + archivePath();
                                busyIndicator.show( 'archiving personal data' );
                                Archive.archive(source,archive,true);
                                enabled = false;
                                unarchiveButton.enabled = false;
                            }
                            function reset() {
                                text = "archive personal data";
                                enabled = true;
                            }
                        }
                        AfterTrauma.Button {
                            id: unarchiveButton
                            anchors.top:archiveButton.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 8
                            backgroundColour: Colours.slate
                            textColour: Colours.almostWhite
                            text: "restore personal data"
                            enabled: profile.hasarchive === undefined ? false : profile.hasarchive
                            onClicked: {
                                console.log( 'ProfileManager : restoring archive' );
                                var path = archivePath()
                                var url = baseURL + path;
                                var target = SystemUtils.documentDirectory() + path;
                                busyIndicator.show( 'downloading personal data' );
                                Downloader.download(url,target);
                                enabled = false;
                                archiveButton.enabled = false;
                            }
                            function reset() {
                                text = "restore personal data";
                                enabled = profile.hasarchive === undefined ? false : profile.hasarchive;
                            }
                        }
                    }
                    */
                    Rectangle {
                        id: updateBlock
                        width: settingsContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        AfterTrauma.Button {
                            id: updateButton
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: 8
                            backgroundColour: Colours.slate
                            textColour: Colours.almostWhite
                            text: "check for updates"
                            onClicked: {
                                updateDialog.open();
                            }
                        }
                    }
                    Rectangle {
                        id: termsBlock
                        width: settingsContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        AfterTrauma.Button {
                            id: termsButton
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: 8
                            backgroundColour: Colours.slate
                            textColour: Colours.almostWhite
                            text: "view terms & conditions"
                            onClicked: {
                                terms.open();
                            }
                        }
                    }
                }
            }
        }
        onCurrentItemChanged: {
            container.title = currentItem.title || "Your Profile"
        }
    }
    //
    //
    //
    footer: Item {
        height: 64
        width: parent.width
        AfterTrauma.Button {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            image: "icons/left_arrow.png"
            visible: contents.currentIndex > 0
            onClicked: {
                contents.decrementCurrentIndex();
            }
        }
        AfterTrauma.PageIndicator {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            currentIndex: contents.currentIndex
            count: contents.count
            colour: Colours.lightSlate
        }
        AfterTrauma.Button {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            image: "icons/right_arrow.png"
            visible: contents.currentIndex < contents.count - 1
            onClicked: {
                contents.incrementCurrentIndex();
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        if ( profile ) {
        } else {
            console.log( 'no profile!' );
        }
        profileChannel.open();
        dirty = false;
    }

    StackView.onDeactivating: {

    }

    StackView.onDeactivated: {
    }
    //
    //
    //
    WebSocketChannel {
        id: profileChannel
        url: baseWS
        //
        //
        //
        onReceived: {
            busyIndicator.hide();
            var command = JSON.parse(message); // TODO: channel should probably emit object
            if( command.status === "OK" ) {
                if ( command.command === 'updateprofile' && command.close ) {
                    stack.pop()
                } else if ( command.command === 'changepassword' ) {
                    confirmDialog.show( '<h1>Password Changed</h1>' );
                    currentPassword.text = "";
                    newPassword.text = "";
                }
            } else {
                errorDialog.show( '<h1>Server says</h1><br/>' + ( typeof command.error === 'string' ? command.error : command.error.error ), [
                                     { label: 'try again', action: function() {} },
                                     { label: 'forget about it', action: function() { stack.pop(); } },
                                 ] );
            }
        }
        onError: {
            busyIndicator.hide();
            errorDialog.show( '<h1>Error</h1><br/>' + error, [
                                 { label: 'try again', action: function() { if ( !isConnected() ) open(); } },
                                 { label: 'forget about it', action: function() { stack.pop(); } },
                             ] );
        }

    }
    //
    //
    //
    function saveProfile(closeManager) {
        JSONFile.write('user.json',profile);
        busyIndicator.show( 'updating profile' );
        profileChannel.send({command:'updateprofile', token: profile.token, profile:profile, close: closeManager});
    }
    function archivePath() {
        return '/media/' + profile.id.replace( /[{}]/g, '') + '.archive';
    }
    //
    //
    //
    Connections {
        target: Archive
        onDone: {
            console.log( 'Archiver : done : ' + operation + ' : ' + source + ' > ' + target );
            if ( operation === "archive" ) {
                busyIndicator.show( 'uploading personal data' );
                Uploader.upload( target, baseWS );
            } else {
                archiveButton.reset();
                unarchiveButton.reset();
                reloadModels();
                busyIndicator.hide();
            }
        }
        onError: {
            console.log( 'Archiver : error : ' + source + ' > ' + target + ' : ' + message );
            busyIndicator.hide();
            errorDialog.show(message);
        }
        onProgress: {
            if ( operation === 'archive' ) {
                busyIndicator.show( 'archiving files ' + Math.floor(( ( current / total ) * 100 )) + '%' );
            } else {
                busyIndicator.show( 'extracting files ' + Math.floor(( ( current / total ) * 100 )) + '%' );
            }
        }
    }
    Connections {
        target: Uploader
        onDone: {
            console.log( 'Uploader : done : ' + source + ' > ' + destination );
            profile.hasarchive = true;
            archiveButton.reset();
            unarchiveButton.reset();
            saveProfile(false);
            busyIndicator.hide();
        }
        onError: {
            console.log( 'Uploader : error : ' + source + ' > ' + destination + ' : ' + message );
            archiveButton.reset();
            busyIndicator.hide();
            errorDialog.show(message);
        }
        onProgress: {
            busyIndicator.show( 'archiving ' + Math.floor(( ( current / total ) * 100 )) + '%' );
            console.log( 'Uploader : progress : ' + source + ' > ' + destination + ' : ' + current + ' of ' + total + ' : ' + message );
        }
    }
    Connections {
        target: Downloader
        onDone: {
            console.log( 'Downloader : done : ' + source + ' > ' + destination );
            var target = SystemUtils.documentDirectory();
            Archive.unarchive(destination,target);
            busyIndicator.show( 'extracting files' );
        }
        onProgress: {
            busyIndicator.show( 'downloading ' + Math.floor(( ( current / total ) * 100 )) + '%' );
        }
    }

    //
    //
    //
    validate: function() {
        if ( profile ) {
            if ( dirty  ) {
                //
                // serialise profile
                //
                confirmDialog.show('<h1>Save Changes?</h1>Do you want to save the changes you have made?', [
                                       { label: 'yes', action: function() { saveProfile(true) } },
                                       { label: 'no', action: function() { profileChannel.close(); stack.pop(); } }
                                   ] );
                return false;
            }
            return true;
        } else {
            return true;
        }
    }
    //
    //
    //
    property bool dirty: false
    property var profile: null
}
