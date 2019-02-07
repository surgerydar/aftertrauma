var express = require('express')
var router  = express.Router()

module.exports = function( authentication, db ) {
    //
    //
    //
    function generateCSV( usage ) {
        function sanitiseString( string ) {
            return string.replace(/"/g, '""') ;  
        };
        let csv = [];
        usage.forEach( function( data ) {
            //
            // header
            //
            if ( csv.length === 0 ) {
                let header = [];
                for ( key in data ) {
                    header.push('"'+key+'"');
                }
                csv.push(header.join(','));
            }
            //
            // row
            //
            let row = [];
            for ( key in data ) {
                var column;
                if ( key === 'date' ) {
                    column = new Date( data[key] ).toISOString();   
                } else if ( key === 'extra' && typeof data[key] !== 'string' ) {
                    let extra = []; 
                    for ( extrakey in data[key] ) {
                        let extravalue = '';
                        if ( extrakey === 'date' ) {
                            extravalue = new Date( data[key][extrakey] ).toISOString();     
                        } else if ( extrakey === 'challenge' ) {
                            let challenge = {
                                name:       data[key][extrakey]['name'],
                                activity:   data[key][extrakey]['activity'],
                                frequency:  data[key][extrakey]['frequency'],
                                repeats:    data[key][extrakey]['repeats']
                            };
                            extravalue += '[';
                            extravalue += 'name=' + data[key][extrakey]['name'];
                            extravalue += ',activity=' + data[key][extrakey]['activity'];
                            extravalue += ',frequency=' + data[key][extrakey]['frequency'];
                            extravalue += ',repeats=' + data[key][extrakey]['repeats'];
                            extravalue += ']';
                        } else {
                            extravalue = data[key][extrakey];
                        }
                        extra.push(extrakey+'='+extravalue);    
                    }
                    column = extra.join(',');
                } else {
                    column = data[key].toString();
                }
                row.push('"'+column+'"');
            }
            csv.push(row.join(','));
           
        });
        return csv.join('\n');
    }
    //
    //
    //
    console.log( 'setting usage routes' );
    router.get('/',authentication, function (req, res) {
        res.render( 'usage', {} );    
    });
    router.get('/report', authentication, function (req, res) { // return all usage between dates
        let startDate = parseInt(req.query.startdate);
        let endDate = parseInt(req.query.enddate);
        let format = req.query.format;
        db.find('usage', { $and: [ { date: { $gte: startDate } }, { date: { $lte: endDate } } ] } ).then( function( usage ) {
            if ( format === 'json' ) {
                res.json({ status: 'OK', response: usage});
            } else if( format === 'csv' ) {
                //res.json({ status: 'OK', response: usage});
                let csv = generateCSV( usage );
                let filename = 'aftertrauma-usage-' + startDate + '-' + endDate + '.csv';
                res.writeHead(200, {
                    'Content-Type': 'text/csv',
                    'Content-Disposition': 'attachment; filename='+filename,
                    'Content-Length': csv.length
                });
                res.end(csv);               
            } else {
                res.render( 'usage', { usage: usage } );
            }
        }).catch( function( error ) {
            console.log( 'usage/report : error : ' + error );
            res.render( 'usage', { error: error.toString() } );
        });
    });
    //
    //
    //
    return router;
}
