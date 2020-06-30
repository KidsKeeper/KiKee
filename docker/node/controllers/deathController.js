const key = "****";
const deathModel = require('../models/death');

exports.index = function (req, res) {
    if( req.params.key == key ) {
        const minx = req.query.minx;
        const miny = req.query.miny;
        const maxx = req.query.maxx;
        const maxy = req.query.maxy;

        const year = req.params.year;

        if(year) {
            deathModel.find({ 'acc_year': year }, (err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json({ data });
            });
        }

        if( req.query.minx && req.query.miny && req.query.maxx && req.query.maxy ) {
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
    }

    else res.status(401).json({ error: 'key is invalid' });
};