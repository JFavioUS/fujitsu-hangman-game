<template>
  <div v-if="finalMessage" class="popup-container" id="popup-container">
    <div class="popup">
      <h2>{{ finalMessage }}</h2>
      <p>The word was: {{ word.join("") }}</p>
      <button @click="reset">Play Again</button>
    </div>
  </div>
</template>

<script>
import { computed } from "vue";
export default {
  props: {
    status: { type: String, default: "" },
    word: { type: String, default: "" },
  },

  setup(props, { emit }) {
    const finalMessage = computed(() => {
      if (props.status === "win") return "Congratulations! You won! 🎉";
      if (props.status === "lose") return "Unfortunately you lost. 😢";

      return "";
    });

    const reset = () => emit("reset");
    return { finalMessage, reset };
  },
};
</script>
