<template>
  <div>
    <h2>Welcome, {{ username }} 👋</h2>
    <div class="messages">
      <div v-for="m in messages" :key="m._id">
        <strong>{{ m.user }}:</strong> {{ m.text }}
      </div>
    </div>
    <input v-model="msg" @keyup.enter="send" placeholder="Type a message..." />
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { io } from "socket.io-client";

const props = defineProps(["username"]);
const socket = io(window.location.origin);
const msg = ref("");
const messages = ref([]);

// รอให้ socket เชื่อมต่อสำเร็จก่อนส่ง join event
socket.on("connect", () => {
  console.log("✅ Socket connected");
  socket.emit("join", props.username);
});

socket.on("message", (m) => {
  console.log("📩 Received message:", m);
  messages.value.push(m);
});

socket.on("connect_error", (err) => {
  console.error("❌ Socket connection error:", err);
});

onMounted(async () => {
  const res = await fetch("/messages");
  messages.value = await res.json();
});

function send() {
  if (msg.value) {
    console.log("📤 Sending message:", msg.value);
    socket.emit("message", msg.value);
    msg.value = "";
  }
}
</script>

<style>
.messages {
  border: 1px solid #ccc;
  padding: 10px;
  height: 300px;
  overflow-y: auto;
  margin-bottom: 10px;
}
</style>
