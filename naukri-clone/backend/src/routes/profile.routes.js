const express = require('express');
const router = express.Router();
const { saveProfile, getProfile } = require('../controllers/profile.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.post('/', authMiddleware, saveProfile);
router.get('/', authMiddleware, getProfile);

module.exports = router;