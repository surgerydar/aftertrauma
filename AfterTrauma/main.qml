import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import SodaControls 1.0
import QtQuick.Dialogs 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours

ApplicationWindow {
    id: appWindow
    visible: true
    width: 320
    height: 640
    //
    //
    //
    title: qsTr("AfterTrauma")
    //
    // global font
    //
    AfterTrauma.Fonts {
        id: fonts
        anchors.fill: parent
        z:10
    }
    //
    // global models
    //
    Settings {
        id: settingsModel
    }
    Daily {
        id: dailyModel
        onDataChanged: {
            //flowerChart.values = dailyModel.valuesForDate( dateSlider.currentDate.getTime() );
            globalMinimumDate = dailyModel.minimumDate();
            globalMaximumDate = dailyModel.maximumDate();
            flowerChart.update();
            if ( questionnaireModel.dailyCompleted() && flowerChartAnimator.running ) flowerChartAnimator.stop()
        }
    }
    Challenges {
        id: challengeModel
    }
    Questionnaires {
        id: questionnaireModel
        onDataChanged: {
            //
            // set global date to today to ensure flower chart displays updated values
            //
            setGlobalDate(new Date());
            //
            //
            //
            if ( dailyCompleted() && flowerChartAnimator.running ) flowerChartAnimator.stop()
        }
    }
    UnreadChats {
        id: unreadChatsModel
    }
    GroupChats {
        id: chatModel
    }
    Categories {
        id: categoryModel
    }
    Documents {
        id: documentModel
    }
    Tags {
        id: tagsModel
    }
    Recomendations {
        id: recomendationModel
    }
    BodyPartList {
        id: bodyPartModel
    }
    Prescriptions {
        id: prescriptionsModel
    }
    Rehab {
        id: rehabModel
        onDataChanged: {
            //flowerChart.maxValues = rehabModel.getGoalValues( dateSlider.currentDate.getTime());
            flowerChart.update();
        }
    }
    Usage {
        id: usageModel
    }
    //
    //
    //
    property var models: [settingsModel,dailyModel,challengeModel,questionnaireModel,unreadChatsModel,chatModel,categoryModel,documentModel,tagsModel,recomendationModel,bodyPartModel,rehabModel,prescriptionsModel]
    function reloadModels() {
        models.forEach( function( model ) {
           model.load();
        });
    }
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Colours.blue }
            GradientStop { position: 1.0; color: Colours.darkBlue }
        }
    }
    //
    //
    //
    FlowerChart {
        id: flowerChart
        height: Math.min(width,parent.height-(112+titleBar.height)) // ensure date slider is on screen
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: titleBar.height
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        enabled: false
        opacity: enabled ? 1. : 0.
        onEnabledChanged: {
            update();
        }
        onCategorySelected: {
            var category = categoryModel.findOne({index:index,section:"resources"});
            stack.push( "qrc:///FactsheetCategory.qml", { title: category.title, colour: Colours.categoryColour(index), category: category.category });
        }
        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
    }
    FlowerChartAnimator {
        id: flowerChartAnimator
        height: titleBar.height
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        interval: 1000
        count: 5
        onNewValues: {
            if ( flowerChart.enabled ) {
                var values = [];
                for ( var i = 0 ; i < count; i++ ) {
                    values.push(value(i));
                }
                flowerChart.values = values;
                flowerChart.update();
            }
        }
    }
    //
    //
    //
    TitleBar {
        id: titleBar
    }
    //
    //
    //
    StackView {
        id: stack
        anchors.fill: parent
        //visible: depth > 1
        anchors.topMargin: depth > 1 ? 0 : titleBar.height
        anchors.bottomMargin: depth > 1 ? 0 : navigationBar.height
        //anchors.bottomMargin: navigationBar.height // JONS: persistant navbar experiment perhaps just add screen height <= 720
        transitions: Transition {
            AnchorAnimation { duration: 100 }
        }
        //
        //
        //
        onDepthChanged: {

        }
        //
        //
        //
        function navigateTo( qmlSource, properties ) {
            var item = find(function(current) {
                //console.log( 'item url:' + current);
                return current.qmlSource === qmlSource;
            });

            if ( item ) {
                pop(item);
            } else {
                item = push(qmlSource, properties);
                if ( item && item.qmlSource !== undefined ) {
                    item.qmlSource = qmlSource;
                }
            }

        }
    }
    //
    //
    //
    function setGlobalDate( date ) {
        globalDate = date;
        flowerChart.maxValues = rehabModel.getGoalValues( globalDate.getTime() );
        flowerChart.values = dailyModel.valuesForDate( globalDate.getTime() );
        flowerChart.update();
    }
    function globalTimeSpan() {

    }
    //
    //
    //
    NavigationBar {
        id: navigationBar
        //
        //
        //
        state: stack.depth > 1 ? "closed" : "open"
        //state: "open" // JONS: persistant navbar experiment
    }

    //
    //
    //
    ChatChannel {
        id: chatChannel
    }
    //
    //
    //
    ShortcutPopup {
        id: shortcut
    }
    BlockEditor {
        id: blockEditor
    }
    GroupChatEditor {
        id: chatEditor
    }
    ProfileViewer {
        id: profileViewer
    }
    DateRangePicker {
        id: dateRangePicker
    }
    MainMenu {
        id: mainMenu
    }
    property var popups: [shortcut,blockEditor,chatEditor,profileViewer,dateRangePicker,mainMenu]
    function closePopUps() {
        popups.forEach( function(popup) {
            try {
                popup.close();
            } catch( e ) {

            }
        });
    }
    //
    // dialogs
    //
    Intro {
        id: intro
        x: 0; y: 0; width: appWindow.width; height: appWindow.height;
    }
    Register {
        id: register
    }
    LinkPopup {
        id: linkPopup
    }
    TermsAndConditions {
        id: terms
    }
    UpdateDialog {
        id: updateDialog
        width: appWindow.width
        height: appWindow.height
    }

    UtilityWindow {
        id: utilityWindow
    }
    AfterTrauma.ConfirmDialog {
        id: confirmDialog
        x: 0
        y: 0
        modal: true
        width: appWindow.width
        height: appWindow.height
    }
    AfterTrauma.ErrorDialog {
        id: errorDialog
        x: 0
        y: 0
        modal: true
        width: appWindow.width
        height: appWindow.height
    }
    //
    //
    //
    AfterTrauma.BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }
    //
    //
    //
    Component.onCompleted: {
        //
        // TODO: check settings for first use
        //
        userProfile = JSONFile.read('user.json') || null;
        if ( !userProfile ) {
            var firstRun = settingsModel.findOne({name:'firstrun'});
            if (  !firstRun || firstRun.value ) {
                settingsModel.update({name:'firstrun'},{value:false},true);
                settingsModel.save();
                console.log( 'installing' );
                Archive.unarchive(":/data/aftertrauma.at",SystemUtils.documentDirectory());
                //
                // initial daily questionnaire notification
                //
                questionnaireModel.scheduleNotification(true);
            }
            intro.open();
        } else {
            //
            // TODO: review the way this works
            //
            if ( userProfile.stayLoggedIn ) {
                loggedIn    = true;
                chatChannel.open();
            } else {
                //
                // force login
                //
                register.open();
                chatChannel.open();
            }
        }
        //
        //
        //
        setGlobalDate(new Date());
        globalMinimumDate = dailyModel.minimumDate();
        globalMaximumDate = dailyModel.maximumDate();
        //
        //
        //
        stack.push("qrc:///Dashboard.qml");
        flowerChart.enabled = true;
        //
        // animate flower chart if no data
        //
        console.log( 'start animator ? count=' + dailyModel.count + ' questionnaire complete=' + questionnaireModel.dailyCompleted() );
        if ( dailyModel.count < 1 && !questionnaireModel.dailyCompleted() ) {
            flowerChartAnimator.start();
        }
     }
    Connections {
        target: Archive
        enabled: stack.depth <= 1
        onDone: {
            busyIndicator.hide();
            categoryModel.load();
            documentModel.load();
            challengeModel.load();
            tagsModel.load();
        }
        onError: {
            busyIndicator.hide();
            errorDialog.show(message);
        }
        onProgress: {
            busyIndicator.show( 'preparing content ' + Math.floor(( ( current / total ) * 100 )) + '%' );
        }
    }
    //
    //
    //
    Connections {
        target: SystemUtils
        //
        //
        //
        onInstallComplete: {
            stack.push("qrc:///Dashboard.qml");
            flowerChart.enabled = true;
            if ( dailyModel.count <= 1 && !questionnaireModel.dailyCompleted() ) {
                flowerChartAnimator.start();
            }
        }
    }
    //
    //
    //
    Shortcut {
        sequence: StandardKey.Back
        onActivated: {
            console.log( 'Back' );
            if ( stack.depth <= 1 ) {
                Qt.quit();
            } else {
                stack.pop();
            }
        }
    }
    Connections {
        target: BackKeyFilter
        onBackKeyPressed : {
            if ( !busyIndicator.running ) {
                if ( Qt.platform.os === 'android' ) {
                    console.log( 'BackKeyFilter.BackKeyPressed' );
                    closePopUps();
                    if ( stack.depth <= 1 ) {
                        Qt.quit();
                    } else {
                        stack.pop();
                    }
                }
            }
        }
        onApplicationActivated: {
            if ( !firstActivation && userProfile && chatChannel.connected ) chatChannel.refresh();
            firstActivation = false;
        }
        onApplicationDeactivated: {

        }
        onApplicationSuspended: {
        }
        property bool firstActivation: true
    }
    //
    //
    //
    Connections {
        target: NotificationManager
        onNotificationReceived: {
            //confirmDialog.show(message);
            var type = NotificationManager.typeFromId(id);
            var subject = NotificationManager.subjectFromId(id);
            var hour = NotificationManager.hourFromId(id);
            console.log( 'NotificationManager.onNotificationReceived : type=' + type + ' subject=' + subject + ' hour=' + hour );
            if ( type === challengeModel.notificationType ) {
                challengeModel.showNotifiedChallenge(subject);
                closePopUps();
            } else if ( type === chatModel.notificationType ) {
                stack.navigateTo("qrc:///GroupChatManager.qml");
                closePopUps();
            } else if ( type === questionnaireModel.notificationType ) {
                stack.navigateTo("qrc:///Questionnaire.qml");
                closePopUps();
            }
        }
    }
    //
    //
    //
    function processLink( url ) {
        console.log( 'link clicked : ' + url  );
        if ( url.startsWith('link://') ) {
            var tag = url.substring('link://'.length);
            linkPopup.find([tag]);
        } else if ( url.startsWith('navigate://') ) {
            var target = url.substring('navigate://'.length);
            console.log( 'navigating to : ' + target );
            switch( target ) {
            case 'diary' :
                stack.navigateTo("qrc:///Diary.qml");
                break;
            case 'chat' :
                stack.navigateTo("qrc:///GroupChatManager.qml");
                break;
            case 'myrecovery' :
                stack.navigateTo("qrc:///Questionnaire.qml");
                break;
            case 'challenges' :
                stack.navigateTo("qrc:///ChallengeManager.qml");
                break;
            case 'myprogress' :
                stack.navigateTo("qrc:///Progress.qml");
                break;
            case 'information' :
                stack.navigateTo("qrc:///FactsheetCategories.qml");
                break;
            }
        } else {
            Qt.openUrlExternally(url);
        }
    }
    //
    // global properties
    //
    property bool loggedIn: false
    property var userProfile: null //testUser()
    property string baseURL: "https://aftertrauma.uk:4000"
    property string baseWS: "wss://aftertrauma.uk:4000"
    property date globalDate: new Date()
    property date globalMinimumDate: new Date()
    property date globalMaximumDate: new Date()
}
