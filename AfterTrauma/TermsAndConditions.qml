import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as AfterTrauma
import "colours.js" as Colours

Popup {
    id: container
    modal: true
    focus: true
    x: 0
    y: 0
    width: appWindow.width
    height: appWindow.height
    //
    //
    //
    background: Item {
        Rectangle {
            height: 64
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: Colours.almostWhite
        }
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 68
            color: Colours.almostWhite
        }
    }
    //
    //
    //
    Item {
        id: header
        height: 64
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        //
        //
        //
        Label {
            id: title
            anchors.fill: parent
            anchors.leftMargin: closeButton.width + 24
            anchors.rightMargin: closeButton.width + 24
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            fontSizeMode: Label.Fit
            color: Colours.veryDarkSlate
            font.pixelSize: 36
            font.weight: Font.Light
            font.family: fonts.light
            text: "TERMS AND CONDITIONS"
        }
        //
        //
        //
        AfterTrauma.Button {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            image: "icons/close.png"
            onClicked: {
                container.close();
            }
        }
    }
    //
    //
    //
    ListView {
        id: content
        anchors.fill: parent
        anchors.topMargin: 68
        clip: true
        spacing: 4
        model: ListModel {}
        delegate: AfterTrauma.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.content
        }
    }
    //
    //
    //
    Component.onCompleted: {
        var blocks = [
                    {
                        "content": "<b>SUMMARY:</b>  The below information is a legal disclaimer to advise you that the information in this app should not be regarded as an alternative to medical advice received from your doctor or other professional healthcare provider.  You should also seek <b>immediate</b> medical attention, if you think you may have any medical condition.  Please do not delay seeking medical advice, disregard medical advice or discontinue medical treatment because of information in this app.   Your use of this app is at your sole risk and no personally identifying data will be collected as a result of using this app. ",
                        "tags": [],
                        "title": "",
                        "type": "text"
                    },
                    {
                        "content": "<b>NO WARRANTY:</b> You expressly acknowledge and agree that use of the application is at your sole risk. To the fullest extent permitted by applicable law, the application and any information it provides or services it performs are provided 'as is' and 'as available,' with all faults and without warranty of any kind, and Queen Mary University of London (<b>QMUL</b>) and Barts Health NHS Trust (<b>BARTS</b>) hereby disclaim all warranties and conditions with respect to the application and any information or services, either express, implied, or statutory, including, but not limited to, any applicable implied warranties and/or conditions of merchantability, of satisfactory quality, of fitness for a particular purpose, of accuracy, of quiet enjoyment, and of non-infringement of third-party rights.  No oral or written information provided by the application or otherwise by QMUL, BARTS or their authorised representative/s will constitute advice nor will it create a warranty.  Neither QMUL nor BARTS will be under any obligation to service, repair or correct the application or any information or services should these prove defective. ",
                        "tags": [],
                        "title": "",
                        "type": "text"
                    },
                    {
                        "content": "This application may be provided through QMUL, BARTS or third party websites. Neither QMUL nor BARTS has control over third party websites and makes no warranties or representations of any kind as to the accuracy or completeness of any information contained in such websites. Inclusion of any third party link in the application or on QMUL or BARTS’ websites, does not imply any endorsement or recommendation by QMUL or BARTS.",
                        "tags": [],
                        "title": "",
                        "type": "text"
                    },
                    {
                        "content": "<b>LIMITATION OF LIABILITY:</b> To the extent not prohibited by applicable law, in no event will QMUL or BARTS be liable for any damages including but not limited to any incidental, special, indirect, or consequential damages whatsoever, including, without limitation, damages for loss of funding or profits, loss of data, business interruption, or any other commercial damages or losses, arising out of or related to your use of or inability to use the application, however caused, regardless of the theory of liability (contract, tort, or otherwise) and even if QMUL or BARTS has been advised of the possibility of such damages. ",
                        "tags": [],
                        "title": "",
                        "type": "text"
                    },
                    {
                        "content": "In respect of third party websites or links, to the fullest extent permitted by applicable law, neither QMUL nor BARTS will have any liability for any damages or injuries of any kind arising from such content or information.",
                        "tags": [],
                        "title": "",
                        "type": "text"
                    },
                    {
                        "content": "<b>DISCLAIMER:</b> This application does not take into account the medical history or health situation of any particular person.  Accordingly, any information in this application is provided to the best of BARTS’s and/or QMUL’s knowledge, is for general guidance only and does not constitute definitive advice.  This application or any information or services should not be relied upon as an alternative to seeking appropriate medical or other healthcare advice from your doctor or other relevant healthcare professional.  You should assess your own need for healthcare advice from a relevant healthcare professional and seek immediate medical attention, if you think you have any health or medical condition.  Please do not delay seeking medical or healthcare advice, or disregard such advice, or discontinue any medical or healthcare treatment because of this application or any information or services.  No personally identifying data will be collected as a result of your use of this application but general information about application usage will be collected for evaluation purposes in accordance with all applicable data protection legislation requirements. ",
                        "tags": [],
                        "title": "",
                        "type": "text"
                    }
                ];
        content.model.clear();
        blocks.forEach(function(block) {
            content.model.append( block );
        });

    }
    onClosed: {
        content.positionViewAtBeginning();
    }
}
