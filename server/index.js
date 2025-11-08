require("dotenv").config();
const express = require("express");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");
const connectDB = require("./db");
const initSocket = require("./socket");
const Message = require("./models/Message");

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static("public"));

app.get("/messages", async (req, res) => {
  const messages = await Message.find().sort({ timestamp: 1 });
  res.json(messages);
});

const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });
initSocket(io);

const PORT = process.env.PORT || 3000;
const MONGO_URL = process.env.MONGO_URL;

connectDB(MONGO_URL);
server.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
