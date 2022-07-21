<template>
  <AppHeader />

  <AppResetButton @reset="startGame" />
</template>

<script>
import router from "../router";

import "../assets/style.css";

import AppHeader from "../components/AppHeader";
import AppResetButton from "../components/AppResetButton";

export default {
  name: "HomeView",
  components: {
    AppHeader,
    AppResetButton,
  },

  setup() {
    const startGame = async () => {
      fetch("http://localhost:3000/game/start-game")
        .then((response) => response.json())
        .then((data) => {
          router.push(`/game/${data.id}`);
        })
        .catch((error) => console.error(error));
    };

    return {
      startGame,
    };
  },
};
</script>
