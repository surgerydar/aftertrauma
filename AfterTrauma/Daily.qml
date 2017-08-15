import QtQuick 2.7

ListModel {
    id: model
    //
    //
    //
    //dynamicRoles: true
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
                result.forEach( function(day) {
                    model.append(day);
                });
                model.updated();
            } else if ( operation === 'update' ) {
                console.log( 'Daily : updated : ' + JSON.stringify(result) );
            }
        }
    }
    function databaseError( collection, operation, error ) {
        console.log( 'database error : ' + collection + ' : ' + operation + ' : ' + error );
    }
    //
    //
    //
    function getDayIndex( date ) {
        var day = date.getDate();
        var month = date.getMonth();
        var year = date.getFullYear();
        var n = model.count;
        //console.log( 'seraching for year:' + year + ' month:' + month + ' day:' + day );
        for ( var i = 0; i < n; i++ ) {
            var item = model.get(i);
            //console.log( 'year:' + item.year + ' month:' + item.month + ' day:' + item.day );
            if ( item.year === year && item.month === month && item.day === day ) {
                //console.log( 'found year:' + item.year + ' month:' + item.month + ' day:' + item.day );
                return i;
            }
        }
        //console.log( 'unable to find year:' + year + ' month:' + month + ' day:' + day );
        return -1;
    }

    function getDay( date ) {
        var index = getDayIndex( date );
        return index >= 0 ? model.get(index ) : undefined;
    }
    function getDayAsObject( date ) {
        var day = getDay(date);
        if ( day ) {
            //
            // convert list fields into arrays
            //
            var _day = {
                _id: day._id,
                date: day.date,
                year: day.year,
                month: day.month,
                day: day.day
            };
            //
            //
            //
            ["notes","images","values"].forEach(function(field){
                if( !Array.isArray(day[field]) ) {
                    //console.log( 'converting ' + field + ' to array');
                    var n = day[field].count;
                    var temp = [];
                    for ( var i = 0; i < n; i++ ) {
                        var object = day[field].get(i);
                        //console.log( 'appending ' + JSON.stringify(object) );
                        temp.push( JSON.parse(JSON.stringify(object)) );
                    }
                    _day[field] = temp;
                }
            });
            //console.log( 'getting : ' + JSON.stringify(_day) );
            return _day;
        }
        return undefined;
    }


    function getToday() {
        var today = new Date();
        var day = getDay( today );
        return day || createToday();
    }
    function getTodayAsObject() {
        var today = new Date();
        var day = getDay( today ) || createToday();
        return getDayAsObject(today);
    }

    function createToday() {
        console.log( 'Daily.createToday')
        var today = new Date();
        var daily = {
            date: today.getTime(),
            year: today.getFullYear(),
            month: today.getMonth(), // 0 - 11
            day: today.getDate(), // 1 - 31
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
        //model.append(daily);
        model.insert(0,daily);
        return model.get(model.count-1);
    }
    //
    // get the closest date to
    //
    function indexOf(date) {
        if (model.count == 0)
            return -1;

        var newest = new Date(model.get(0).date);
        var oldest = new Date(model.get(model.count - 1).date);
        if (newest <= date)
            return 0; //???

        if (oldest >= date)
            return model.count - 1;

        var currDiff = 0;
        var bestDiff = Math.abs(date.getTime() - newest.getTime());
        var retval = 0;
        for (var i = 0; i < model.count; i++) {
            var d = new Date(model.get(i).date);
            currDiff = Math.abs(d.getTime() - date.getTime());
            if (currDiff < bestDiff) {
                bestDiff = currDiff;
                retval = i;
            }
            if (currDiff > bestDiff)
                return retval;
        }

        return -1;
    }
    //
    //
    //
    function update( day ) {
        var index = getDayIndex(new Date(day.date));
        if ( index >= 0 ) {
            /*
            console.log( 'updating day : ' + JSON.stringify(day) + ' at index : ' + index );
            var updatedDay = Database.update('daily', { _id: day._id }, day );
            console.log( 'updated day : ' + JSON.stringify(updatedDay) + ' at index : ' + index );
            Database.save();
            */
            //
            //
            //
            model.set(index,day);
            model.updated();
            /*
            //
            // convert list fields into arrays
            //
            var _day = {
                _id: day._id,
                date: day.date,
                year: day.year,
                month: day.month,
                day: day.day
            };
            //
            //
            //
            ["notes","images","values"].forEach(function(field){
                if( !Array.isArray(day[field]) ) {
                    console.log( 'converting ' + field + ' to array');
                    var n = day[field].count;
                    var temp = [];
                    for ( var i = 0; i < n; i++ ) {
                        var object = day[field].get(i);
                        console.log( 'appending ' + JSON.stringify(object) );
                        temp.push( object );
                    }
                    _day[field] = temp;
                }
            });
            console.log( 'updating : ' + JSON.stringify(_day) );
            model.set(index,_day);
            */
        }
    }
}
