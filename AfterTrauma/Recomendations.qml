import QtQuick 2.7
import SodaControls 1.0

DatabaseList {
    id: model
    collection: "recomendations"
    roles: [ 'category', 'minimum', 'maximum', 'recomendation', 'links' ]
    //
    //
    //
    Component.onCompleted: {
        //
        //
        //
        if ( count <= 0 ) {
            console.log( 'generating recomentation test data');
            var data = [
                        // body
                        {
                            category: "body",
                            minimum: 0.0,
                            maximum: 0.34,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "body-1"
                        },
                        {
                            category: "body",
                            minimum: 0.34,
                            maximum: 0.67,
                            recomendation: "You’re making good progress! Keep it up!",
                            tag: "body-2"
                        },
                        {
                            category: "body",
                            minimum: 0.67,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            tag: "body-3"
                        },
                        // emotions
                        {
                            category: "emotions",
                            minimum: 0.0,
                            maximum: 0.34,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "emotions-1"
                        },
                        {
                            category: "emotions",
                            minimum: 0.34,
                            maximum: 0.67,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "emotions-2"
                        },
                        {
                            category: "emotions",
                            minimum: 0.67,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            tag: "emotions-3"
                        },
                        // relationships
                        {
                            category: "relationships",
                            minimum: 0.0,
                            maximum: 0.34,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "relationships-1"
                        },
                        {
                            category: "relationships",
                            minimum: 0.34,
                            maximum: 0.67,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "relationships-2"
                        },
                        {
                            category: "relationships",
                            minimum: 0.67,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            tag: "relationships-3"
                        },
                        // life
                        {
                            category: "life",
                            minimum: 0.0,
                            maximum: 0.34,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "life-1"
                        },
                        {
                            category: "life",
                            minimum: 0.34,
                            maximum: 0.67,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "life-2"
                        },
                        {
                            category: "life",
                            minimum: 0.67,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            tag: "life-3"
                        },
                        // confidence
                        {
                            category: "confidence",
                            minimum: 0.0,
                            maximum: 0.34,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "confidence-1"
                        },
                        {
                            category: "confidence",
                            minimum: 0.34,
                            maximum: 0.67,
                            recomendation: "Some difficulties. Need some help?",
                            tag: "confidence-2"
                        },
                        {
                            category: "confidence",
                            minimum: 0.67,
                            maximum: 1.0,
                            recomendation: "You’re making good progress! Keep it up!",
                            tag: "confidence-3"
                        }
                   ];
            beginBatch();
            data.forEach(function(datum) {
                //console.log( 'adding recommendation : ' + JSON.stringify(datum) );
                batchAdd(datum);
            });
            endBatch();
            save();
        }
    }
    //
    //
    //
    function getRecomendation( c ) {
        console.log( 'getRecomendation : get daily : ' + c );
        var daily = dailyModel.getToday();
        if ( !daily || !daily.values ) {
            console.log( 'getRecomendation : unable to find valid daily : ' + daily ? "undefined" : JSON.stringify(daily));
            return 'unable to find daily results';
        }
        console.log( 'getRecomendation : daily : ' + JSON.stringify( daily.values ) );
        //
        // get category value
        //
        var value = 0.;
        for ( var i = 0; i < daily.values.length; i++ ) {
            if ( daily.values[ i ].label === c ) {
                value = daily.values[ i ].value;
                break;
            }
        }
        //
        // get category value recomendation
        //
        var query = { $and: [ { category: c }, { minimum: { $lte: value } }, { maximum: { $gte: value } } ]};
        console.log( 'getRecomendation : looking for : ' + JSON.stringify( query ) );
        var recomendation = findOne( query );
        var text;
        if ( recomendation ) {
            text = recomendation.recomendation;
            if ( recomendation.tag && recomendation.tag.length > 0 && linkPopup.getFrequency([recomendation.tag]) ) {
                text += '<br/><a class="recommendation" href="link://' + recomendation.tag + '">' + c + ' resources</a>';
            }
        } else {
            text = 'Insufficient information to assess : ' + c;
        }
        //
        //
        //
        return text;
    }
}
