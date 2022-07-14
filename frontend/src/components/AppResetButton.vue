<template>
  <div class="game-reset-button">
    <button @click="reset">New Game</button>
  </div>
</template>

<script>
export default {
  setup(props, { emit }) {
    const reset = () => emit("reset");
    return { reset };
  },
};
</script>
