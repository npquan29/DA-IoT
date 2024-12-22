const coap = require("coap"); 
const fetch = require("node-fetch");
const crypto = require("crypto");
const dotenv = require("dotenv");
const cors = require("cors");
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const { connectToDatabase } = require("./db");
const SupportData = require("./models/SupportData");
const supportDataRoutes = require('./routes/SupportDataRoutes');
const authRoutes = require('./routes/AuthRoutes');
const userRoutes = require('./routes/UserRoutes');

dotenv.config();

const app = express();

app.use(express.json()); // Parse JSON payload
app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE"]
}));

const httpServer = http.createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: "*", // Cho phép mọi nguồn hoặc chỉ định URL của frontend
    methods: ["GET"]
  },
});

const key = "WJv4mZt9Pq2x8LhT5rQn3DfU6gJbYzA1"; 

// Hàm giải mã AES
function decryptData(encryptedData) {
  const parts = encryptedData.split(":"); 
  const iv = Buffer.from(parts[0], "base64"); 
  const encryptedText = parts[1]; 

  const decipher = crypto.createDecipheriv("aes-256-cbc", Buffer.from(key), iv);
  let decrypted = decipher.update(encryptedText, "base64", "utf8");
  decrypted += decipher.final("utf8");

  return decrypted; // Trả về chuỗi JSON gốc
}

async function getAddressFromCoordinates(lat, lon) {
  const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}`;

  const response = await fetch(url);
  if (response.ok) {
    const data = await response.json();
    return data.display_name;
  } else {
    throw new Error("Failed to fetch address");
  }
}

const coapServer = coap.createServer();

coapServer.on("request", async (req, res) => {
  // GET EndPoint from client
  // const endPoint = req.url;

  try {
    const encryptedData = req.payload.toString(); 
    const decodedData = decryptData(encryptedData); 
    const jsonObject = JSON.parse(decodedData);

    const [latitude, longitude] = jsonObject.position
      .split(",")
      .map((coord) => coord.trim());

    // const address = await getAddressFromCoordinates(latitude, longitude);
    // console.log("Received JSON object:", jsonObject);

    const newData = await SupportData.create({
      latitude,
      longitude,
      deviceId: jsonObject.deviceId,
      temperature: jsonObject.temperature,
      humidity: jsonObject.humidity,
      light: jsonObject.light,
      pressure: jsonObject.pressure,
      heartRate: jsonObject.heartRate,
      bodyTemperature: jsonObject.bodyTemperature,
    });

    io.emit('newData', newData);

    // Phản hồi cho client Flutter
    res.code = "2.05";
    res.end("Rescue teams are moving to your location.");
  } catch (error) {
    console.error("Error processing message:", error);
    res.code = "5.00";
    res.end("Error processing data");
  }
});

connectToDatabase();

app.use('/api/v1/data', supportDataRoutes);
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/user', userRoutes);

// Lắng nghe trên cổng 5683
coapServer.listen(() => {
  console.log("Server CoAP đang chạy trên cổng 5683");
});

httpServer.listen(3000, () => {
  console.log('Express server with Socket.IO is running on http://localhost:3000');
});
