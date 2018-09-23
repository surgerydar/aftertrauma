import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "rehab"
    roles: [ "id", "date", "blocks", "goals" ]
    sort: { "date": -1 }
    //
    //
    //
    Component.onCompleted: {
        //
        // test data
        //
        if ( false ) { //count <= 0 ) {
            beginBatch();
            for ( var i = 0 ;i < 3; i++ ) {
                var p = {
                    id: GuidGenerator.generate(),
                    date: Date.now(),
                    blocks: [],
                    goals: [
                        { name: 'emotions', value: 1.0 },
                        { name: 'confidence', value: 1.0 },
                        { name: 'body', value: 1.0 },
                        { name: 'life', value: 1.0 },
                        { name: 'relationships', value: 1.0 }
                    ]
                };
                batchAdd(p);
            }
            endBatch();
            save();
        }
    }
    //
    //
    //
    function getPlan( date ) {
        var candidate = null;
        var min = Number.MAX_VALUE;
        for ( var i = 0; i < count; i++ ) {
            var plan = get(i);
            var d = Math.abs( date - plan.date );
            if ( d < min ) {
                min = d;
                candidate = plan;
            }
        }
        return candidate;
    }
    function getGoalValues( date ) {
        var prescription = getPlan( date );
        if ( prescription ) {
            var goals = [];
            prescription.goals.forEach( function( goal ) {
                goals.push( goal.value );
            } );
            return goals;
        }
        return [ 1.,1.,1.,1.,1.];
    }

}
