const express = require('express');
const { getAllSupportData } = require('../controllers/SupportController');
const router = express.Router();

router.get("/", getAllSupportData);

module.exports = router;