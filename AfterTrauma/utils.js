
var longMonths = ["January","February","March","April","May","June","July","August","September","October","November","December"];
var shortMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
var dayMs=1000*60*60*24;

function longMonth(month) {
    return longMonths[ month ];
}

function shortMonth(month) {
    return shortMonths[ month ];
}

function shortDate(time,withYear) {
    var date = new Date(time);
    return date.getDate() + ', ' + shortMonths[ date.getMonth() ] + ( withYear ? ', ' + date.getFullYear() : '' );
}

function shortDateVertical(time,withYear) {
    var date = new Date(time);
    return date.getDate() + '<br/>' + shortMonths[ date.getMonth() ] + ( withYear ? '<br/>' + date.getFullYear() : '' );
}


function daysBetweenDates( date1, date2 ) {
    var ms1 = date1.getTime();
    var ms2 = date2.getTime();
    return daysBetweenMs(ms1,ms2);
}

function daysBetweenMs( ms1, ms2 ) {
    var dMs = ms2 - ms1;
    return Math.round(dMs/dayMs);
}

function getLastDate( start ) {
    var month = start.getMonth();
    var date = start.getDate();
    var temp = new Date(start);
    try {
        do {
            date = temp.getDate();
            temp.setDate(temp.getDate()+1);
        } while( temp.getMonth() === month );
    } catch( err ) {
        console.log( 'getLastDate : error : ' + err );
        console.log( 'temp : ' + temp );
    }

    return date;
}

function getStartOfWeek( start ) {
    var temp = new Date( start );
    while( temp.getDay() > 0 ) temp.setDate(temp.getDate()-1);
    return temp;
}

function getEndOfWeek( start ) {
    var temp = new Date( start );
    while( temp.getDay() < 6 ) temp.setDate(temp.getDate()+1);
    return temp;
}

function formatAgeAndGender( profile ) {
    console.log( 'Utils.formatAgeAndGender(' + JSON.stringify(profile) + ')' );
    return ( profile.age ?  profile.age + ' ' : '' ) + ( profile.gender === 'male' || profile.gender === 'female' ? profile.gender : '' );
}

function formatChallengeDescription( activity, repeats, frequency ) {
    return activity + '<p><b>' + 'repeat ' + repeats + ' time' + ( repeats > 1 ? 's ' : ' ' ) + ', ' + challengeFrequencyLabel( frequency ) + '</b></p>';
}

function challengeFrequencyLabel( canonical, capitalise ) {
    var labels = {
        hourly : "hourly",
        fourtimesdaily : "four times daily",
        morningandevening : "morning and evening",
        daily : "daily",
        weekly : "weekly"
    };
    if ( labels[ canonical ] ) {
        if ( capitalise ) {
            return labels[ canonical ].charAt(0).toUpperCase() + labels[ canonical ].slice(1);
        }
        return labels[ canonical ];
    }
    return canonical;
}

function challengeFrequencyCanonical( label ) {
    return label.replace(/\s+/g, '').toLowerCase();
}

function map( value, valueMin, valueMax, targetMin, targetMax ) {
    return ( ( value - valueMin ) / ( valueMax - valueMin ) ) * ( targetMax - targetMin ) + targetMin;
}
