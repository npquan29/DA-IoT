const { Sequelize } = require("sequelize");

const sequelize = new Sequelize("rescue", "root", "quan2910", {
    host: "localhost",
    dialect: "mysql",
    timezone: "+07:00", 
    logging: false
});

const connectToDatabase = async () => {
    try {
        await sequelize.authenticate();
        console.log(
            "Connection to the database has been established successfully."
        );
    } catch (error) {
        console.error("Unable to connect to the database:", error);
        throw error; // Ném lỗi để xử lý trong server.js
    }
};

module.exports = { sequelize, connectToDatabase };
