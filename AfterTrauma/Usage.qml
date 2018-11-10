import QtQuick 2.7
import SodaControls 1.0

Item {
    id: container
    visible: false
    //
    //
    //
    UsageModel {
        id: model
    }
    //
    //
    //
    //
    //
    //
    WebSocketChannel {
        id: channel
        url: baseWS

        //
        //
        //
        onReceived: {
            var command = JSON.parse(message);
            if ( command.status === "OK" ) {
                if ( command.command === 'usagesyncrequest' ) {
                    var usage = model.find({date:{$gt:command.response}});
                    if ( usage.length > 0 ) {
                        //
                        // upload usage data
                        //
                        send( {
                                 command: 'usagesync',
                                 usageid : getUsageId(),
                                 usage: usage
                             } );
                    } else {
                        close();
                    }
                } else if ( command.command === 'usagesync' ) {
                    //
                    // synced so clear local data
                    //
                    model.clear();
                    model.save();
                    close();
                }
            } else if ( command.error ) {
                console.log( 'UsageModel : error : ' + ( typeof command.error === 'string' ? command.error : command.error.error ) );
                close();
            } else {
                console.log( 'UsageModel : unknown message : ' + message );
            }
        }
        onError: {
            console.log( 'UsageModel : network error : ' + error );
            close();
        }
        onOpened: {
            //
            // send sync request
            //
            send({
                     command: 'usagesyncrequest',
                     usageid: getUsageId()
                 });
        }
    }
    //
    //
    //
    Timer {
        id: syncTimer
        interval: 1000 * 60 * 10
        repeat: true
        running: true
        onTriggered: {
            if ( !channel.isConnected() ) {
                channel.open();
            }
        }
    }
    /*
      section   : app | recovery | diary | chat | information | challenges | progress | rehab | profile | search | about | settings
      action    : enter | leave | add | remove | edit | select | search | share
      item      : image | text | chat | message | question | diary
      extra     : context specific data eg date range for diary / progress share

      */
    function add( section, action, item, extra ) {
        console.log( 'Usage : adding : ' + section + ' : ' + action + ' : ' + item + ' : ' + JSON.stringify(extra) );

        model.add({
                      date    : Date.now(),
                      section : section || "unspecified",
                      action  : action || "unspecified",
                      item    : item || "unspecified",
                      extra   : extra || "unspecified"
            });
        model.save();

    }
    function getUsageId() {
        var usageid;
        var usage = settingsModel.findOne({name:'usageid'});
        if ( usage ) {
             usageid = usage.value;
        } else {
            usageid = GuidGenerator.generate();
            settingsModel.add( { name:'usageid', value: usageid } );
            settingsModel.save();
        }
        return usageid;
    }
}
