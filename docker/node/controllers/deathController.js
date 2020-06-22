const key = "****";
const deathModel = require('../models/death');

exports.index = function (req, res) {
    if( req.params.key == key ) {
        const year = req.params.yaer;

        if(year) {
            deathModel.find({ 'acc_year': year }, (err, data) => {
                if(err) return res.status(500).json({ error: 'db error' });
                if( Object.keys(data).length === 0 ) return res.status(404).json({ error: 'no data'});
                res.json(data);
            });
        }

        deathModel.find((err, data) => {
            if(err) return res.status(500).json({ error: 'db error' });
            res.json(data)
        });
    }

    else res.status(401).json({ error: 'key is invalid' });
};