const { DataTypes } = require('sequelize');
const {sequelize} = require("../db.js");

const SupportData = sequelize.define('SupportData', {
  latitude: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  longitude: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  deviceId: {
    type: DataTypes.STRING,
  },
  temperature: {
    type: DataTypes.INTEGER,
  },
  humidity: {
    type: DataTypes.INTEGER,
  },
  light: {
    type: DataTypes.INTEGER,
  },
  pressure: {
    type: DataTypes.INTEGER,
  },
  heartRate: {
    type: DataTypes.INTEGER,
  },
  bodyTemperature: {
    type: DataTypes.INTEGER,
  },
}, {
  timestamps: true,
});

module.exports = SupportData;