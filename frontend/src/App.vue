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
        <AppWord :letters="letters" :correct-letters="correctLetters" />
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

import dataJSON from "./assets/englishWords.json";

const { words } = dataJSON;
const randomWord = () => words[Math.floor(Math.random() * words.length)];

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
    const word = ref(randomWord());
    const guessedLetters = ref([]);
    const manualInputLetter = ref("");
    const manualGameType = ref(true);
    const NUMBER_GUESSES = 10;
    const letters = computed(() => word.value.split(""));
    const wrongLetters = computed(() =>
      guessedLetters.value.filter((letter) => !letters.value.includes(letter))
    );
    const correctLetters = computed(() =>
      guessedLetters.value.filter((letter) => letters.value.includes(letter))
    );
    const guessesLeft = computed(
      () => NUMBER_GUESSES - wrongLetters.value.length
    );

    const status = computed(() => {
      if (wrongLetters.value.length === NUMBER_GUESSES) return "lose";
      if (
        letters.value.every((letter) => correctLetters.value.includes(letter))
      )
        return "win";

      return "";
    });

    const reset = () => {
      guessedLetters.value = [];
      word.value = randomWord();
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

    return {
      letters,
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
    };
  },
};
</script>
