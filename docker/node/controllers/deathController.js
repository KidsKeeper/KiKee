const helpers = require('./helpers');
const deathModel = require('../models/death');

exports.index = function (req, res) {
    const keyResult = helpers.keyCheck(req.params.key);

    switch( keyResult ) {
        case 1:
            let minx = req.query.minx;
            let miny = req.query.miny;
            let maxx = req.query.maxx;
            let maxy = req.query.maxy;

            if( minx && miny && maxx && maxy ) {
                [ minx, miny, maxx, maxy ] = helpers.squareFind( minx, miny, maxx, maxy );

                deathModel.find({ la_crd:{$gt: minx, $lt: maxx}, lo_crd:{$gt: miny, $lt: maxy} }, (err, data) => {
                    if(err) return res.status(500).json({ error: 'db error' });
                    if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                    res.json({ data });
                });
            }

            else {
                deathModel.find((err, data) => {
                    if(err) return res.status(500).json({ error: 'db error' });
                    res.json({ data })
                });
            }

        case 2:
            res.status(401).json({ error: 'key is invalid' });
            break;
    }
};