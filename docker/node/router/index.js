const router = require('express').Router();
const frequentlyController = require('../controllers/frequentlyController');
const deathController = require('../controllers/deathController');
const storeController = require('../controllers/storeController');

router.get( '/:key/api/frequently/:kind?/:year?', frequentlyController.index );
router.get( '/:key/api/death/:year?', deathController.index );
router.get( '/:key/api/store', storeController.index );

module.exports = router