<template>
  <h2>Guesses Left: {{ guessesLeft }}</h2>
</template>

<script>
export default {
  props: {
    guessesLeft: { type: Number, default: 10 },
  },
};
</script>
