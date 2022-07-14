<template>
  <button class="chooseGame" @click="changeGameMode">
    {{ gameType ? "Automatic" : "Manual" }}
  </button>
</template>

<script>
export default {
  props: {
    gameType: { type: Boolean },
  },

  setup(props, { emit }) {
    const changeGameMode = () => emit("changeGameMode");

    return { changeGameMode };
  },
};
</script>
