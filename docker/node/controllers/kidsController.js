const helpers = require('./helpers');
const kidsModel = require("../models/kids");
const kidslocationModel = require("../models/kidslocation");

// /kids/id/compare
exports.compare = function (req, res) {
    console.log('kids id compare connect');

    const kidsId = req.body['kidsId'];

    if(kidsId) {
        kidsModel.find({ kidsId: kidsId }, (err, data) => {
            if(err) console.log(err);

            if( Object.keys(data).length === 0 ) {
                var kids = new kidsModel({ kidsId: kidsId, key: null }); // make kids data form.
                kids.save(function (err, data) {});

                res.send( kidsId.toString() );
            }

            else {
                kidsModel.find({}, (err, data) => {
                    let savedId = helpers.makeRandomNumber(); // generate a new key when kidsId is duplicated from flutter.
                    let count = 0;
    
                    const length = data.length;
    
                    while( count < 1 ) { // to avoid duplication of kidsId, loop the function.
                        for( let i = 0; i < length; i++ ) {
                            if( data[i]['kidsId'] == savedId ) savedId = helpers.makeRandomNumber(); // if kidsId is duplicated, regenerate.
                            else count++;
                        }
                    }

                    var kids = new kidsModel({ kidsId: savedId, key: null }); // make kids data form.
                    kids.save(function (err, data) {}); // insert data.
    
                    res.send( savedId.toString() ); // throw kidsId not duplicated.
                });
            }
        })
    }

    else res.send('no id');
}

// /kids/key/create
exports.create = function (req, res) {
    console.log('create a key');

    const kidsId = req.body['kidsId'];

    if( kidsId ) {
        kidsModel.find({ kidsId: kidsId, key: null }, (err, data) => { // find case kidsId is existed and key value is null
            if( Object.keys(data).length === 0 ) res.send('no id or key exist');

            else {
                const key = helpers.keyGenerator();

                kidsModel.updateOne({ kidsId: kidsId }, { key: key }, { upsert: true }, function (err, data) {
                    if(err) console.log(err);
                    else console.log('key generated');
                });

                var kidslocation = new kidslocationModel({
                    kidsId: kidsId,
                    parentsId: null,
                    lon: null,
                    lat: null,
                    start: null,
                    end: null,
                    polygon: null,
                    status: 0
                }); // make kidslocation data form.
                kidslocation.save(function (err, data) {});

                res.status(401).json({ 'result': 1, 'key': key });
            }
        });
    }

    else res.status(401).json({ 'result': 0, 'key': null });
}

// /kids/location/start
exports.start = function (req, res) { // 로컬의 플루터 디비에서 키값이 있는지 확인하고 이 쪽으로 들어옴.
    console.log('map start');

    const kidsId = req.body['kidsId'];
    const key = req.body['key'];

    if( kidsId && key ) {
        kidslocationModel.find({ kidsId: kidsId, key: key }, (err, kdata) => {
            if(err) console.log(err);
            console.log(kdata);

            const length = Object.keys(kdata).length;

            if( length === 0 ) res.send('id is wrong');

            const polygon = req.body['polygon'];
            const start = req.body['start'];
            const end = req.body['end'];

            if( polygon ) {
                if( kdata[0]['status'] == false ) { // 처음으로 길 찾기를 시작 했을 때 초기 정보 업데이트.
                    var moment = require('moment');
                    var currentDate = moment().format('YYYY-MM-DD HH:mm');

                    kidslocationModel.updateOne({ kidsId: kidsId }, {
                        start: start,
                        end: end,
                        polygon: polygon,
                        status: true,
                        date: currentDate
                    }, { upsert: true }, function (err, data) { if(err) console.log(err); });
                    // kidslocationModel.insertOne({
                    //     kidsId: kidsId,
                    //     start: start,
                    //     end: end,
                    //     polygon: polygon,
                    //     status: true
                    // }, function (err, data) { if(err) console.log(err); });
                }

                else { // 초기 정보를 넣고 나서 지속적으로 위경도 데이터 업데이트.
                    var lon = req.body['lon'];
                    var lat = req.body['lat'];

                    while( kdata[ length - 1 ]['status'] == false ) { // 마지막 기록이 false가 될 때 까지 반복.
                        kidslocationModel.updateOne({ kidsId: kidsId }, {
                            lat: lat,
                            lon: lon,
                        }, { upsert: true }, function (err, data) { if(err) console.log(err); });
                    }
                }

                // if( kdata[0]['status'] == false ) { // 처음으로 길 찾기를 시작 했을 때 초기 정보 업데이트.
                //     console.log('status is false');

                //     // print(polygon);

                //     kidslocationModel.insertOne({
                //         kidsId: kidsId,
                //         start: start,
                //         end: end,
                //         polygon: polygon,
                //         status: true
                //     }, function (err, data) { if(err) console.log(err); });

                //     // kidslocationModel.updateOne(
                //     //     { kidsId: kidsId },
                //     //     { start: start, end: end, polygon: polygon, status: true },
                //     //     function (err, data) { if(err) console.log(err); });

                //     res.send('1');
                // }

                // else { // 초기 정보를 넣고 나서 지속적으로 위경도 데이터 업데이트.
                //     const lon = req.body['lon'];
                //     const lat = req.body['lat'];

                //     // kidslocationModel.updateOne(
                //     //     { kidsId: kidsId },
                //     //     { lon: lon, lat: lat },
                //     //     function (err, data) { if(err) console.log(err); });

                //     kidslocationModel.insertOne({
                //         lon: lon,
                //         lat: lat
                //     }, function (err, data) { if(err) console.log(err); });

                //     res.send('1'); // 위경도 데이터를 잘 받고 저장 했다면 1를 던져줌.
                // }
            }

            else res.send('no polygon or current ');
        });
    }

    else res.send('no id or key');
}

// /kids/location/end
exports.end = function (req, res) {
    const kidsId = req.body['kidsId'];
    const key = req.body['key'];

    if( kidsId && key ) {
        kidslocationModel.find({ kidsId: kidsId, key: key }, (err, kdata) => {
            if( Object.keys(kdata).length === 0 ) res.send('key is wrong');

            kidslocationModel.insertOne({
                kidsId: kidsId,
                // lat: lat,
                // lon: lon,
                // start: start,
                // end: end,
                // polygon: polygon,
                status: false
            }, function (err, data) { if(err) console.log(err); });

            // if( kdata[0]['status'] == 1 ) { // 길 찾기를 종료하는데 status가 1이면 0으로 업데이트 하기.
            //     kidslocationModel.updateOne({ status: false }, { upsert: true }, function (err, data) {});
            //     return res.send(1);
            // }
        });
    }

    else res.send('no id or key');
}
