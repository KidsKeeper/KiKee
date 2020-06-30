const key = "****";
const storeModel = require('../models/store');

exports.index = function (req, res) {
    if( req.params.key == key ) {
        const minx = req.query.minx;
        const miny = req.query.miny;
        const maxx = req.query.maxx;
        const maxy = req.query.maxy;

        if( req.query.minx && req.query.miny && req.query.maxx && req.query.maxy ) {
            storeModel.find({ lat:{$gt: minx, $lt: maxx}, lon:{$gt: miny, $lt: maxy} }, (err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json({ data });
            });
        }

        else {
            storeModel.find((err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                res.json({ data })
            });
        }
    }

    else res.status(401).json({ error: 'key is invalid' });
};