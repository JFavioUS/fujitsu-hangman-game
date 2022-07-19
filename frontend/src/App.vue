<template>
  <AppHeader />
  <div class="game-container">
    <div class="game-info">
      <AppGuessesLeft :guesses-left="guessesLeft" />
      <WrongLetters :wrong-letters="wrongLetters" />
      <AppResetButton @reset="reset" />
    </div>
    <div class="game-word">
      <div>
        <AppWord
          :letters="expectedLetters"
          :correct-letters="correctLetters"
          :word-length="wordLength"
        />
        <AppInputLetter
          @guess-letter="manualInput"
          @manual-change="manualInputChange"
          :manual-letter="manualInputLetter"
          :disabled="manualGameType"
        />
      </div>

      <AppChooseGame
        @change-game-mode="changeGameMode"
        :gameType="manualGameType"
      />
    </div>
  </div>
  <AppPopup :status="status" :word="word" @reset="reset" />
  <AppNotification :show="notification" />
</template>

<script>
import { computed, ref } from "vue";

import "./assets/style.css";

import AppHeader from "./components/AppHeader";
import WrongLetters from "./components/WrongLetters";
import AppWord from "./components/AppWord";
import AppPopup from "./components/AppPopup";
import AppNotification from "./components/AppNotification";
import AppGuessesLeft from "./components/AppGuessesLeft";
import AppResetButton from "./components/AppResetButton";
import AppInputLetter from "./components/AppInputLetter";
import AppChooseGame from "./components/AppChooseGame";

import onKeydown from "./assets/onKeydown.js";

export default {
  components: {
    AppHeader,
    AppWord,
    WrongLetters,
    AppPopup,
    AppNotification,
    AppGuessesLeft,
    AppResetButton,
    AppInputLetter,
    AppChooseGame,
  },

  setup() {
    const word = ref("");
    const wordLength = ref(0);
    const guessedLetters = ref([]);
    const manualInputLetter = ref("");
    const manualGameType = ref(true);
    const NUMBER_GUESSES = 10;
    const expectedLetters = computed(() => word.value.split(""));
    const wrongLetters = computed(() =>
      guessedLetters.value.filter(
        (letter) => !expectedLetters.value.includes(letter)
      )
    );
    const correctLetters = computed(() =>
      guessedLetters.value.filter((letter) =>
        expectedLetters.value.includes(letter)
      )
    );
    const guessesLeft = computed(
      () => NUMBER_GUESSES - wrongLetters.value.length
    );

    const status = computed(() => {
      if (wrongLetters.value.length === NUMBER_GUESSES) return "lose";
      if (
        expectedLetters.value.every((letter) =>
          correctLetters.value.includes(letter)
        )
      )
        return "win";

      return "";
    });

    const reset = () => {
      guessedLetters.value = [];
      startGame();
    };

    const notification = ref(false);
    const showNotification = () => {
      notification.value = true;
      setTimeout(() => (notification.value = false), 2000);
    };

    const manualInputChange = (event) => {
      manualInputLetter.value = event.target.value;
    };

    const manualInput = () => {
      const letter = manualInputLetter.value.toLowerCase();
      const keyCode = {
        keyCode: manualInputLetter.value.charCodeAt(0),
      };

      if (letter && validInput(keyCode, letter)) {
        guessedLetters.value.push(letter);
        manualInputLetter.value = "";
      }
    };

    const validInput = ({ keyCode }, letter) => {
      if (!manualGameType.value && (keyCode < 65 || keyCode > 90)) return false;
      if (status.value) return false;
      if (guessedLetters.value.includes(letter)) {
        showNotification();
        return false;
      }

      return true;
    };

    const changeGameMode = () => {
      manualGameType.value = !manualGameType.value;
    };

    onKeydown((event) => {
      if (!manualGameType.value) {
        const letter = event.key.toLowerCase();
        if (validInput(event, letter)) {
          guessedLetters.value.push(letter);
        }
      }
    });

    const startGame = () => {
      fetch("http://localhost:3000/game/start-game")
        .then((response) => response.json())
        .then((data) => {
          wordLength.value = data.randomWord;
        })
        .catch((error) => console.error(error));
    };

    startGame();

    return {
      expectedLetters,
      word,
      wrongLetters,
      correctLetters,
      guessedLetters,
      guessesLeft,
      notification,
      status,
      reset,
      manualInputLetter,
      manualInput,
      manualInputChange,
      changeGameMode,
      manualGameType,
      wordLength,
    };
  },
};
</script>
