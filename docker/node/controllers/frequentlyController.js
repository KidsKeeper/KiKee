const key = "****";
const frequentlyModel = require('../models/frequently');

exports.index = function (req, res) {
    if( req.params.key == key ) {
        const kind = req.params.kind;
        const year = req.params.year;

        if(kind) {
            frequentlyModel.find({ "kind": kind },(err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json(data);
            });
        }

        else if(year) {
            frequentlyModel.find({ "kind": kind, "afos_id": year },(err, data) => {
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

    else res.status(401).json({ error: 'key is invalid' });
};