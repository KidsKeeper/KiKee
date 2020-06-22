const key = "****";
const storeModel = require('../models/store');

exports.index = function (req, res) {
    if( req.params.key == key ) {
        storeModel.find((err, data) => {
            if(err) return res.status(500).json({ error: 'db error' });
            res.json(data)
        });
    }

    else res.status(401).json({ error: 'key is invalid' });
};