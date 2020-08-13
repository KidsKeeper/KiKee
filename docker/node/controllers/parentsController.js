const helpers = require('./helpers');
const parentsModel = require("../models/parents");
const parentskidsModel = require("../models/parentskids");
const kidsModel = require("../models/kids");
const kidslocationModel = require("../models/kidslocation");

// /parents/id/compare
exports.compare = function (req, res) {
    console.log('parents id compare connect');
    
    const parentsId = req.body['parentsId'];

    if( parentsId ) {
        parentsModel.find({ parentsId: parentsId }, (err, data) => {
            if(err) console.log(err);

            if( Object.keys(data).length === 0 ) {
                var parents = new parentsModel({ parentsId: parentsId, key: null }); // make parents data form.
                parents.save(function (err, data) {});

                res.send( parentsId.toString() ); // db insert success.
            }

            else {
                parentsModel.find({}, (err, data) => {
                    let savedId = helpers.makeRandomNumber(); // generate a new key when parentsid is duplicated from flutter.
                    let count = 0;

                    const length = data.length;

                    while( count < 1 ) { // to avoid duplication of parentsid, loop the function.
                        for( let i = 0; i < length; i++ ) {
                            if( data[i]['parentsId'] == savedId ) savedId = helpers.makeRandomNumber(); // if parentsid is duplicated, regenerate.
                            else count++;
                        }
                    }

                    var parents = new parentsModel({ parentsId: savedId, key: null }); // make parents data form.
                    parents.save(function (err, data) {}); // insert data.

                    res.send( savedId.toString() ); // throw parentsid not duplicated.
                });
            }
        });
    }

    else res.send('no id');
}

// /parents/key/confirm
exports.confirm = function (req, res) {
    const parentsId = req.body['parentsId'];
    const name = req.body['name'];
    const key = req.body['key'];

    if( parentsId && key ) {
        kidsModel.find({ key: key }, (err, kdata) => { // check key from parents app with kids key saved before. kdata => kids data.
            if(err) console.log(err);

            if( Object.keys(kdata).length === 0 ) res.status(401).json({ 'result': 0, 'kidsId': -1 });// res.send('key is wrong');

            else {
                parentsModel.updateOne({ parentsId: parentsId }, { key: key }, { upsert: true }, function (err, data) {
                    if(err) {
                        console.log(err);
                        res.send('db error');
                    }

                    var kidsId = kdata[0]['kidsId'];

                    parentskidsModel.find({ kidsId: kidsId }, (err, pkdata) => {
                        if( Object.keys(pkdata).length === 0 ) {
                            var parentskids = new parentskidsModel({ parentsId: parentsId, kidsId: kidsId, name: name });
                            parentskids.save(function (err, data) {});
                        }

                        else {
                            console.log('parentskids => kidsid is duplicated');
                        }
                    })

                    res.status(401).json({ 'result': 1, 'kidsId': kidsId });
                });
            }
        });
    }

    else res.send('no id or key');
}

// /parents/location/get
exports.get = function (req, res) {
    console.log('parents start to get location');

    const kidsId = req.body['kidsId'];
    // const key = req.body['key'];

    if( kidsId ) {
        kidslocationModel.find({ kidsId: kidsId }, (err, data) => {
            if(err) console.log(err);

            const length = Object.keys(data).length;

            if( length === 0 ) res.send('no data');

            else { // 데이터가 있고
                for( var i = 0; i < length; i++ ) {
                    if( data[i]['status'] == false && data[i]['polygon'] != null ) { // 길 찾기를 하고 길 찾기가 끝난 상태라면
                        console.log('delete data ' + kidsId.toString() );
                        kidslocationModel.deleteOne({ kidsId: kidsId }, (err, ddata) => { // 데이터를 가지고 가면 있던 데이터 삭제.
                            if(err) console.log(err);
                            res.send('db error');
                        });
                        res.json({ data });
                    }
                }
            }
        });
    }

    else res.send('no id or key');
}