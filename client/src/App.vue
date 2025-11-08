<template>
  <div class="app">
    <LoginForm v-if="!username" @login="setUser" />
    <ChatRoom v-else :username="username" />
  </div>
</template>

<script setup>
import { ref } from "vue";
import LoginForm from "./components/LoginForm.vue";
import ChatRoom from "./components/ChatRoom.vue";

const username = ref(null);
function setUser(name) {
  username.value = name;
}
</script>

<style>
.app {
  font-family: sans-serif;
  text-align: center;
  margin-top: 30px;
}
</style>
