const key = "****";
const frequentlyModel = require('../models/frequently');

exports.index = function (req, res) {
    if( req.params.key == key ) {
        const minx = req.query.minx;
        const miny = req.query.miny;
        const maxx = req.query.maxx;
        const maxy = req.query.maxy;
        
        const kind = req.params.kind;
        const year = req.params.year;

        if(kind) {
            frequentlyModel.find({ "kind": kind }, (err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json(data);
            });
        }

        else if(year) {
            frequentlyModel.find({ "kind": kind, "afos_id": year }, (err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json(data);
            });
        }

        else {
            if( req.query.minx && req.query.miny && req.query.maxx && req.query.maxy ) {
                frequentlyModel.find({ la_crd:{$gt: minx, $lt: maxx}, lo_crd:{$gt: miny, $lt: maxy} }, (err, data) => {
                    if(err) return res.status(500).json({ error: 'db error' });
                    if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                    res.json(data);
                });
            }

            else {
               frequentlyModel.find((err, data) => {
                    if(err) return res.status(500).json({ error: 'db error' });
                    res.json(data);
                });
            }
        }
    }

    else res.status(401).json({ error: 'key is invalid' });
};