const helpers = require('./helpers');
const parentsModel = require("../models/parents");
const parentskidsModel = require("../models/parentskids");
const kidsModel = require("../models/kids");
const kidslocationModel = require("../models/kidslocation");
const kidspolygonModel = require("../models/kidspolygon");

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
exports.location = function (req, res) {
    console.log('parents start to get location');

    const kidsId = req.body['kidsId'];
    console.log(kidsId);
    // const parnetsId = req.body['parnetsId'];

    if( kidsId ) {
        kidslocationModel.find({ kidsId: kidsId }, (err, ldata) => {
            console.log(ldata);
            if(err) console.log(err);
            if( Object.keys(ldata).length == 0 ) res.send('no data');
            if( ldata[0]['status'] == true ) {
                console.log('status is ture');
                res.json({ ldata });
            }

            else { res.send('no data'); }
        });
    }

    else res.send('no id');
}

// /parents/polygon/get
exports.polygon = function (req, res) {
    console.log('parents start to get polygon');

    const kidsId = req.body['kidsId'];

    if( kidsId ) {
        kidspolygonModel.find({ kidsId: kidsId }, (err, pdata) => {
            const length = Object.keys(pdata).length;

            if(err) console.log(err);
            if( length === 0 ) res.send('[Server] no data');
            else {
                for( var i = 0; i < length; i++ ) {
                    if( pdata[i]['polygon'] != null ) { // 길 찾기를 하고 길 찾기가 끝난 상태라면
                        console.log('delete data ' + kidsId.toString() );

                        kidspolygonModel.deleteOne({ kidsId: kidsId }, (err, ddata) => { // 데이터를 가지고 가면 있던 데이터 삭제.
                            if(err) console.log(err);
                        });
                    }
                }
                console.log(pdata);
                res.json({ pdata });
                // res.send('noting to update');
            }
        });
    }

    else res.send('no id');
}

// /parents/nowlocation/get
// exports.nowget = function (req, res) { // 길 찾기 중이라면 현재 상태를 보낸다.
//     console.log('parents start to get now location');

//     const kidsId = req.body['kidsId'];

//     if( kidsId ) {
//         kidslocationModel.find({ kidsId: kidsId }, (err, data) => {
//             if(err) console.log(err);

//             const length = Object.keys(data).length;

//             if( length === 0 ) res.send('no data');

//             if( data[length - 1]['status'] == 'true' ) { // 마지막의 kidslocation 데이터가 길 찾기 중인 경우.
//                 res.json({
//                     'lat': data[length - 1]['lat'],
//                     'lon': data[length - 1]['lon'],
//                     'polygon': data[length - 1]['polygon']
//                 });
//             }

//             else res.send('no data');
//         });
//     }

//     else res.send('no id');
// }

// // /parents/pastlocation/get
// exports.pastget = function (req, res) { // 이전 길 찾기 경로를 보내기 위해.
//     console.log('parents start to get past location');

//     const kidsId = req.body['kidsId'];
//     // const key = req.body['key'];

//     if( kidsId ) {
//         kidslocationModel.find({ kidsId: kidsId }, (err, data) => {
//             if(err) console.log(err);

//             const length = Object.keys(data).length;

//             if( length === 0 ) res.send('no data');

//             else { // 데이터가 있고
//                 for( var i = 0; i < length; i++ ) {
//                     if( data[i]['status'] == false && data[i]['polygon'] != null ) { // 길 찾기를 하고 길 찾기가 끝난 상태라면
//                         console.log('delete data ' + kidsId.toString() );
//                         kidslocationModel.deleteOne({ kidsId: kidsId }, (err, ddata) => { // 데이터를 가지고 가면 있던 데이터 삭제.
//                             if(err) console.log(err);
//                         });

//                         res.json({ data });
//                     }
//                 }
//                 res.send('noting to update');
//             }
//         });
//     }

//     else res.send('no id');
// }