const helpers = require('./helpers');
const cctvModel = require('../models/cctv');

exports.index = function (req, res) {
    const keyResult = helpers.keyCheck(req.params.key);

    switch( keyResult ) {
        case 1:
            cctvModel.find((err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json({ data });
            });

        case 2:
            res.status(401).json({ error: 'key is invalid' });
            break;
    }
}