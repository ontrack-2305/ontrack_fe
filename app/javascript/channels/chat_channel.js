// Import ActionCable
import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer();

const chat = consumer.subscriptions.create("ChatChannel", {
  connected() {
    console.log('Connected to Chat Channel');
  },

  received(data) {
    this.appendMessageToChat(data.message);
  },

  speak(message) {
    this.perform('speak', { message: message });
  },

  appendMessageToChat(message) {
    const chatBox = document.querySelector('#chat-box');
    const msgElement = document.createElement('p');
    msgElement.textContent = message;
    chatBox.appendChild(msgElement);
  }
});
