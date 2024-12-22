const express = require('express');
const { edit } = require('../controllers/UserController');
const router = express.Router();

router.patch("/:id", edit);

module.exports = router;