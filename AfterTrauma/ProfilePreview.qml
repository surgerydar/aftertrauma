import QtQuick 2.7
import QtQuick.Controls 2.1
import SodaControls 1.0

import "controls" as AfterTrauma
import "colours.js" as Colours
import "utils.js" as Utils

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
    //
    //
    //
    ListView {
        id: contents
        anchors.fill: parent
        anchors.margins: 4
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: AfterTrauma.Block {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            type: model.type
            media: model.content
            onMediaReady: {
                contents.forceLayout();
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        title.text = profile.username;
        contents.model.clear();
        contents.model.append( {
                                  type: 'image',
                                  content: profile.avatar || "qrc:///icons/profile_icon.png"
                              });
        if ( profile.age || profile.gender )
            contents.model.append( {
                                      type: 'text',
                                      content: Utils.formatAgeAndGender( profile )
                                  });
        if ( profile.profile && profile.profile.length > 0 )
            contents.model.append( {
                                      type: 'text',
                                      content: profile.profile
                                  });
        if ( profile.tags && profile.tags.length > 0 )
            contents.model.append( {
                                      type: 'text',
                                      content: profile.tags.join()
                                  });
    }
    //
    //
    //
    property var profile: null
}
