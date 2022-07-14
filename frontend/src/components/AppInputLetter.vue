<template>
  <h2>Enter Guess</h2>
  <div class="guess-letter-input">
    <input
      type="text"
      :value="manualLetter"
      @input="$emit('manualChange', $event)"
      minlength="1"
      maxlength="1"
      :disabled="!disabled"
    />
    <button @click="guessLetter" :disabled="!disabled">Guess!</button>
  </div>
</template>

<script>
// defineProps(["manualLetter"]);
// defineEmits(["guessLeter", "manualChange"]);
export default {
  props: {
    manualLetter: { type: String, default: "" },
    disabled: { type: Boolean },
  },

  emits: ["guessLetter", "manualChange"],

  setup(props, { emit }) {
    const guessLetter = () => emit("guessLetter");
    const manualChange = () => emit("manualChange");

    return { manualChange, guessLetter };
  },
};
</script>
