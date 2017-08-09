import QtQuick 2.7

ListModel {
    id: model
    //
    //
    //

    Component.onCompleted: {
        //
        // initial find
        //
        Database.find('daily',{},{date: -1});
    }
    /*
    Connections {
        target: Database

        onSuccess: {
            if ( collection === 'daily' && operation === 'find' ) {
                console.log( 'Daily : loading daylies' );
                model.clear();
                result.forEach( function(daily) {
                    model.append(daily);
                });
                model.updated();
            }
        }
    }
    */
    //
    //
    //
    signal updated();
    //
    //
    //
    function databaseSuccess( collection, operation, result ) {
        if ( collection === 'daily' ) {
            if ( operation === 'find' ) {
                console.log( 'Daily : loading daylies' );
                model.clear();
                result.forEach( function(daily) {
                    /*
                    console.log( 'appending daily : ' + JSON.stringify(entry));
                    var object = {
                        date: entry.date,
                        year: entry.year,
                        month: entry.month, // 0 - 11
                        day: entry.day, // 1 - 31
                        values: entry.values,
                        notes: entry.notes,
                        images: entry.images
                    };
                    model.append(object);
                    */
                    model.append(daily);
                });
                model.updated();
            }
        }
    }
    function databaseError( collection, operation, error ) {
        console.log( 'database error : ' + collection + ' : ' + operation + ' : ' + error );
    }
    //
    //
    //

    function getToday() {
        var today = new Date();
        var day = today.getDate();
        var month = today.getMonth();
        var year = today.getYear();
        var n = model.count;
        for ( var i = 0; i < n; i++ ) {
            var item = model.get(i);
            if ( item.year === year && item.month === month && item.day === day ) {
                return item;
            }
        }
        return createToday();
    }
    function createToday() {
        var today = new Date();
        var daily = {
            date: day.getTime(),
            year: day.getFullYear(),
            month: day.getMonth(), // 0 - 11
            day: day.getDate(), // 1 - 31
            values: [
                { name: 'emotions', value: 0. },
                { name: 'mind', value: 0. },
                { name: 'body', value: 0. },
                { name: 'life', value: 0. },
                { name: 'relationships', value: 0. },
            ],
            notes: [],
            images: []
        }
        Database.insert('daily',daily);
        Database.save();
        model.append(daily);
        return daily;
    }
}
