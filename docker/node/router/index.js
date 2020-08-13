const router = require('express').Router();

const frequentlyController = require('../controllers/frequentlyController');
const deathController = require('../controllers/deathController');
const storeController = require('../controllers/storeController');
const parentsController = require('../controllers/parentsController');
const kidsController = require('../controllers/kidsController');

router.post( '/parents/id/compare', parentsController.compare );
router.post( '/parents/key/confirm', parentsController.confirm );
router.post( '/parents/location/nowget', parentsController.nowget );
router.post( '/parents/location/pastget', parentsController.pastget );

router.post( '/kids/id/compare', kidsController.compare );
router.post( '/kids/key/create', kidsController.create );
router.post( '/kids/location/start', kidsController.start );
router.post( '/kids/location/end', kidsController.end );

router.get( '/:key/api/frequently', frequentlyController.index );
router.get( '/:key/api/death', deathController.index );
router.get( '/:key/api/store', storeController.index );

router.get( '/key', frequentlyController.key );

module.exports = router