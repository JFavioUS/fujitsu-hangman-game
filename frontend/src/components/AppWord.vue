<template>
  <div class="word">
    <span class="letter" v-for="(letter, i) in wordLength" :key="i">
      {{ "" }}
    </span>
  </div>
</template>

<script>
export default {
  props: {
    letters: { type: Array, required: true },
    correctLetters: { type: Array, default: () => [] },
    wordLength: { type: Number, required: true },
  },
};
</script>
