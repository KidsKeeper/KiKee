const key = '****';

module.exports = function ( app, frequently, death ) {
    app.get('/:key', (req, res) => {
        if( req.params.key == key )
            res.json({result: 'good'});
        else
            res.json({error: 'no'});
    });

    app.get('/:key/api/frequently', (req, res) => {
        if( req.params.key == key ) {
            frequently.find((err, data) => {
                if(err) return res.status(500).json({ error: 'database failure' });
                res.json(data);
            });
        }
        
        else
            res.status(401).json({ error: 'key is invaild' });
    });

    app.get('/api/frequently/:kind/:year?', (req, res) => {
        if( req.params.year ) {
            frequently.find({ "kind": req.params.kind, "afos_id": req.params.year }, (err, data) => {
                if(err) return res.status(500).json({ error: 'database failure' });
                if( Object.keys(data).length === 0 ) { console.log('1'); return res.status(404).json({ error: 'no data'}); }
            
                res.json(data);
            });
        }

        else {
            frequently.find({ "kind": req.params.kind }, (err, data) => {
                if(err) return res.status(500).json({ error: 'database failure' });
                if( Object.keys(data).length === 0 ) { console.log('2'); return res.status(404).json({ error: 'no data'}); }
            
                res.json(data);
            });
        }
    });

    app.get('/api/death', (req, res) => {
        death.find((err, data) => {
            if(err) return res.status(500).json({ error: 'database failure' });
            res.json(data);
        });
    });

    app.get('/api/death/:year', (req, res) => {
        death.find({ "acc_year": req.params.year }, (err, data) => {
            if(err) return res.status(500).json({ error: 'database failure' });
            if( Object.keys(data).length === 0 ) { console.log('2'); return res.status(404).json({ error: 'no data'}); }
            
            res.json(data);
        });
    });
}