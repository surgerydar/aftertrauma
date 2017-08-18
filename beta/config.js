let fs = require('fs');

exports.ssl = {
    key: fs.readFileSync('./ssl/privkey.pem'),
    cert: fs.readFileSync('./ssl/fullchain.pem'),
    ca: fs.readFileSync('./ssl/chain.pem')
}