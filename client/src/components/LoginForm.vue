<template>
  <div>
    <h2>Enter your name</h2>
    <input v-model="name" placeholder="Your name" />
    <button @click="login">Join Chat</button>
  </div>
</template>

<script setup>
import { ref } from "vue";
const emit = defineEmits(["login"]);
const name = ref("");
function login() {
  if (name.value) emit("login", name.value);
}
</script>
