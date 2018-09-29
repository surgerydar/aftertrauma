import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours
import "../styles.js" as Styles

Label {
    id: control
    height: 48
    color: Colours.veryDarkSlate
    padding: 8
    verticalAlignment: Label.AlignVCenter
    horizontalAlignment: Label.AlignHCenter
    font.pointSize: 24
    wrapMode: Label.WordWrap
    textFormat: Label.RichText
    //
    //
    //
    onLinkActivated: {
        processLink(link);
    }
    onTextChanged: {
        control.text = Styles.style(text,"global");
    }
}
