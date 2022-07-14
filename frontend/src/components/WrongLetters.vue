<template>
  <div class="wrong-letters-container">
    <div class="wrong-letters">
      <h2>Wrong Guesses</h2>
      <div class="wrong-letters-box">
        <span v-for="(letter, i) in wrongLetters" :key="letter">
          {{ letter }}
          {{ i === wrongLetters.length - 1 ? "" : " " }}
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    wrongLetters: { type: Array, default: () => [] },
  },
};
</script>
