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
    title: profile.username || "About You"
    colour: Colours.almostWhite
    //
    //
    //
    SwipeView {
        id: contents
        anchors.fill: parent
        //
        //
        //
        Page {
            padding: 0
            //title: "About You"
            title: profile.username || "About You"
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
            //
            //
            //
            Flickable {
                id: profileContainer
                anchors.fill: parent
                clip: true
                contentHeight: profileItems.childrenRect.height + 16
                //
                //
                //
                MouseArea {
                    anchors.top: profileItems.top
                    anchors.left: profileItems.left
                    anchors.bottom: profileItems.bottom
                    anchors.right: profileItems.right
                    onClicked: {
                        Qt.inputMethod.hide();
                    }
                }
                //
                //
                //
                Column {
                    id: profileItems
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 4
                    //
                    //
                    //
                    Rectangle {
                        id: dateBlock
                        width: profileContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Label {
                            id: dateHeader
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            color: Colours.veryDarkSlate
                            fontSizeMode: Label.Fit
                            font.family: fonts.light
                            font.pointSize: 24
                            text: "Date of injury"
                        }
                        AfterTrauma.DatePicker {
                            id: injuryDate
                            height: 128
                            width: dateBlock.width - 8
                            anchors.top: dateHeader.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 4
                            textMonth: true
                            onCurrentDateChanged: {
                                // TODO: initialisation causes this to fire FIXIT
                                // dirty = true;
                            }
                        }
                    }
                    //
                    //
                    //
                    Rectangle {
                        id: profileBlock0
                        width: profileContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Label {
                            id: roleHeader
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            color: Colours.veryDarkSlate
                            fontSizeMode: Label.Fit
                            font.family: fonts.light
                            font.pointSize: 24
                            text: "Who is the person filling in this profile?"
                        }
                        AfterTrauma.CheckBox {
                            id: patient
                            anchors.top: roleHeader.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "I have the injury"
                            checked: profile ? profile.role === "patient" : true
                            onCheckedChanged: {
                                dirty = true;
                                carer.checked = !checked;
                            }
                        }
                        AfterTrauma.CheckBox {
                            id: carer
                            anchors.top: patient.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "I am the carer"
                            checked: profile ? profile.role === "carer" : false
                            onCheckedChanged: {
                                dirty = true;
                                patient.checked = !checked;
                            }
                        }
                        //
                        //
                        //
                        Label {
                            id: ageLabel
                            anchors.top: age.top
                            anchors.bottom: age.bottom
                            anchors.right: age.left
                            anchors.rightMargin: 4
                            color: Colours.veryDarkSlate
                            verticalAlignment: Label.AlignVCenter
                            font.family: fonts.light
                            font.pointSize: 18
                            text: "Age"
                        }
                        AfterTrauma.TextField {
                            id: age
                            width: 64
                            anchors.top: carer.bottom
                            anchors.topMargin: 16
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            validator: IntValidator {
                                top: 150
                                bottom: 0
                            }
                            text: profile && profile.age ? profile.age : ""
                            onTextChanged: {
                                dirty = true;
                            }
                        }
                    }
                    Rectangle {
                        id: profileBlock1
                        width: profileContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Label {
                            id: genderHeader
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 8
                            color: Colours.veryDarkSlate
                            wrapMode: Label.WordWrap
                            font.family: fonts.light
                            font.pointSize: 24
                            text: "Gender"
                        }
                        AfterTrauma.CheckBox {
                            id: female
                            anchors.top: genderHeader.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "Female"
                            checked: profile ? profile.gender === "female" : false
                            onCheckedChanged: {
                                dirty = true;
                                if ( checked ) {
                                    male.checked = false;
                                    nogender.checked = false;
                                }
                            }
                        }
                        AfterTrauma.CheckBox {
                            id: male
                            anchors.top: female.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "Male"
                            checked: profile ? profile.gender === "male" : false
                            onCheckedChanged: {
                                dirty = true;
                                if ( checked ) {
                                    female.checked = false;
                                    nogender.checked = false;
                                }
                            }
                        }
                        AfterTrauma.CheckBox {
                            id: nogender
                            anchors.top: male.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            direction: "Right"
                            text: "Rather not say"
                            checked: profile ? profile.gender === "notspecified" : true
                            onCheckedChanged: {
                                dirty = true;
                                if ( checked ) {
                                    female.checked = false;
                                    male.checked = false;
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: avatarBlock
                        width: profileContainer.width
                        height: width
                        color: Colours.almostWhite
                        //
                        //
                        //
                        Image {
                            id: avatar
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.bottom: galleryButton.top
                            anchors.right: parent.right
                            anchors.margins: 16
                            fillMode: Image.PreserveAspectFit
                            source: profile && profile.avatar ? profile.avatar : "icons/profile_icon.png"
                            onStatusChanged: {
                                if( status === Image.Error ) {
                                    source = "icons/profile_icon.png";
                                }
                            }
                            //
                            //
                            //
                        }
                        AfterTrauma.Button {
                            id: galleryButton
                            anchors.bottom: parent.bottom
                            anchors.left: parent.horizontalCenter
                            anchors.leftMargin: 1
                            text: "gallery"
                            backgroundColour: Colours.darkSlate
                            radius: [0]
                            onClicked: {
                                ImagePicker.openGallery();
                            }
                        }
                        AfterTrauma.Button {
                            id: cameraButton
                            anchors.bottom: parent.bottom
                            anchors.right: parent.horizontalCenter
                            anchors.rightMargin: 1
                            text: "camera"
                            backgroundColour: Colours.darkSlate
                            radius: [0]
                            onClicked: {
                                ImagePicker.openCamera();
                            }
                        }
                    }
                    Rectangle {
                        id: profileTextBlock
                        height: profileText.height + 16
                        width: profileContainer.width
                        color: Colours.almostWhite
                        //
                        //
                        //
                        AfterTrauma.ScrollableTextArea {
                            id: profileText
                            height: Math.max(contentHeight,128)
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            placeholderText: "Tell us a little about you and your trauma experience"
                            text: profile && profile.profile ? profile.profile : ""
                            onTextChanged: {
                                dirty = true;
                            }
                        }
                    }
                    //
                    //
                    //
                    Rectangle {
                        id: previewBlock
                        width: profileContainer.width
                        height: childrenRect.height + 16
                        color: Colours.almostWhite
                        //
                        //
                        //
                        AfterTrauma.Button {
                            id: previewButton
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 8
                            backgroundColour: Colours.slate
                            textColour: Colours.almostWhite
                            text: "preview public profile"
                            onClicked: {
                                stack.navigateTo("qrc:///ProfilePreview.qml",{ profile: profile });
                            }
                        }
                    }

                }
            }
        }
        Page {
            padding: 0
            title: "Where are your injuries?"
            BodyParts {
                anchors.fill: parent
                onPartSelected: {
                    dirty = true;
                    if ( selected ) {
                        if ( !profile.tags ) {
                            profile.tags = [ name ];
                        } else {
                            if ( profile.tags.indexOf(name) < 0 ) {
                                profile.tags.push(name);
                            }
                        }
                        if ( !profile.injuries ) {
                            profile.injuries = {};
                        }
                        if ( !profile.injuries[ name ] ) {
                            profile.injuries[ name ] = "";
                        }
                    } else {
                        if ( profile.tags ) {
                            var i = profile.tags.indexOf(name);
                            if ( i >= 0 ) {
                                profile.tags.splice(i,1);
                            }
                        }
                        if ( profile.injuries && profile.injuries[ name ]) {
                            delete profile.injuries[ name ];
                        }
                    }
                }
            }
        }
        //
        // injury description
        //
        Page {
            id: injuryDescriptionPage
            visible: profile && profile.tags && profile.tags.length > 0
            padding: 0
            title: "Describe your injuries"
            ListView {
                id: injuryDescriptionList
                anchors.fill: parent
                //
                //
                //
                clip: true
                model: profile.tags
                //
                //
                //
                delegate: Rectangle {
                    height: childrenRect.height + 16
                    width: injuryDescriptionList.width
                    color: Colours.almostWhite
                    //
                    //
                    //
                    Label {
                        id: injuryDescriptionHeader
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: 8
                        color: Colours.veryDarkSlate
                        wrapMode: Label.WordWrap
                        font.family: fonts.light
                        font.pointSize: 24
                        text: profile.tags[ index ]
                    }
                    //
                    //
                    //
                    AfterTrauma.ScrollableTextArea {
                        id: injuryDescriptionText
                        height: 128
                        anchors.top: injuryDescriptionHeader.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 8
                        placeholderText: "Tell us a little about your " + profile.tags[ index ] + " injury"
                        text: profile.injuries && profile.injuries[ profile.tags[ index ] ] ? profile.injuries[ profile.tags[ index ] ] : ""
                        onTextChanged: {
                            if ( !profile.injuries ) {
                                profile.injuries = {};
                            }
                            profile.injuries[ profile.tags[ index ] ] = text;
                            dirty = true;
                        }
                    }
                }
            }
            //
            //
            //
            SwipeView.onIsCurrentItemChanged: {
                if ( SwipeView.isCurrentItem ) {
                    injuryDescriptionList.model = profile.tags;
                }
            }

        }
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
                        width: profileContainer.width
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
                        width: profileContainer.width
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
                            anchors.right: parent.right
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
                    Rectangle {
                        id: archiveBlock
                        width: profileContainer.width
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
                                Archive.archive(source,archive);
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
        dirty = false;
        if ( profile ) {
            console.log( 'profile:' + profile.username );
            injuryDate.currentDate = profile.injuryDate ?  new Date( profile.injuryDate ): new Date()
        } else {
            console.log( 'no profile!' );
        }
        profileChannel.open();
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

    }
    //
    //
    //
    Connections {
        target: ImagePicker
        onImagePicked: {
            // TODO: ensure this isn't called from addImage
            console.log( 'ProfileManager : setting profile avatar');
            var encoded = ImageUtils.urlEncode(url, 256, 256);
            avatar.source = encoded;
            if( profile ) {
                dirty = true;
                profile.avatar = encoded;
            }
        }
    }
    //
    //
    //
    function saveProfile(closeManager) {
        profile.injuryDate = injuryDate.currentDate.getTime();
        if ( patient.checked ) {
            profile.role = "patient";
        } else if ( carer.checked ) {
            profile.role = "carer";
        }
        if ( female.checked ) {
            profile.gender = "female";
        } else if ( male.checked ) {
            profile.gender = "male";
        } else {
            profile.gender = "notspecified";
        }
        if ( age.text.length > 0 && age.acceptableInput ) {
            profile.age = parseInt(age.text);
        } else {
            profile.age = undefined;
        }
        profile.profile = profileText.text;
        if ( profile.tags ) {
            console.log( 'profile tags: ' + JSON.stringify(profile.tags));
        }
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
            if ( dirty || profile.injuryDate !== injuryDate.currentDate.getTime() ) {
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
