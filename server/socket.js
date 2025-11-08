const Message = require("./models/Message");

function initSocket(io) {
  io.on("connection", (socket) => {
    console.log("🟢 User connected");

    socket.on("join", (username) => {
      socket.username = username;
      console.log(`👤 User joined: ${username}`);
      socket.broadcast.emit("user_joined", username);
    });

    socket.on("message", async (msg) => {
      console.log(`💬 Message received from ${socket.username}: ${msg}`);
      const message = await Message.create({
        user: socket.username || "Anonymous",
        text: msg,
      });
      console.log(`✅ Message saved to DB:`, message);
      io.emit("message", message);
    });

    socket.on("disconnect", () => {
      console.log("🔴 User disconnected");
    });
  });
}

module.exports = initSocket;
