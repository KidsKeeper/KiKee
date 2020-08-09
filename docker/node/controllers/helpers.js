const keyCheck = function (key) {
    const secret = '****';
    return (secret == key) ? 1 : 2;
}

const squareFind = function ( minx, miny, maxx, maxy ) {
    if( minx > maxx ) [ minx, maxx ] = [ maxx, minx ];
    if( miny > maxy ) [ miny, maxy ] = [ maxy, miny ];

    return [ minx, miny, maxx, maxy ];
}

const keyGenerator = function () {
    const characters = "0123456789abcdefghijklmnopqrstuvwxyz!@#$%*";
    const length = 8;
    let key = "";

    for( let i = 0; i < length; i++ ) {
        let random = Math.floor( Math.random() * characters.length );
        key += characters.substring( random, random + 1 );
    }

    return key;
}

const makeRandomNumber = function () {
    return Math.floor( Math.random() * (100 - 0) + 0 );
}

module.exports.keyCheck = keyCheck;
module.exports.squareFind = squareFind;
module.exports.keyGenerator = keyGenerator;
module.exports.makeRandomNumber = makeRandomNumber;