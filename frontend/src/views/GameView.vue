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
        <AppWord :letters="word" :correct-letters="correctLetters" />
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
import { ref, onMounted } from "vue";
import router from "../router";

import "../assets/style.css";

import AppHeader from "../components/AppHeader";
import WrongLetters from "../components/WrongLetters";
import AppWord from "../components/AppWord";
import AppPopup from "../components/AppPopup";
import AppNotification from "../components/AppNotification";
import AppGuessesLeft from "../components/AppGuessesLeft";
import AppResetButton from "../components/AppResetButton";
import AppInputLetter from "../components/AppInputLetter";
import AppChooseGame from "../components/AppChooseGame";

import onKeydown from "../assets/onKeydown.js";

export default {
  name: "GameView",
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
    const manualInputLetter = ref("");
    const manualGameType = ref(true);
    const gameId = ref(router.currentRoute.value.params.id);
    const gameInfo = ref({
      id: 0,
      word: 0,
      status: "active",
      allLetters: "",
      rightLetters: "",
      wrongLetters: "",
      totalGuesses: 10,
      tries: 10,
      finished: false,
    });
    const word = ref(gameInfo.value.word);
    const wrongLetters = ref(gameInfo.value.wrongLetters.split(""));
    const correctLetters = ref(gameInfo.value.rightLetters.split(""));
    const guessesLeft = ref(gameInfo.value.tries);
    const status = ref(gameInfo.value.status);

    const reset = () => {
      startGame();
      gameInfo.value = {
        id: 0,
        word: 0,
        status: "active",
        allLetters: "",
        rightLetters: "",
        wrongLetters: "",
        totalGuesses: 10,
        tries: 10,
        finished: false,
      };
    };

    const makeGuess = async (letter) => {
      const bodyObject = JSON.stringify({
        letterGuessed: letter,
      });

      await fetch(`http://localhost:3000/game/${gameId.value}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: bodyObject,
      })
        .then((response) => response.json())
        .catch((err) => console.error(err));

      await getGameInfo(gameId.value);
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
        makeGuess(letter);
        manualInputLetter.value = "";
      }
    };

    const validInput = ({ keyCode }, letter) => {
      console.log("hi", status.value);
      if (!manualGameType.value && (keyCode < 65 || keyCode > 90)) return false;
      if (status.value === "win" || status.value === "lose") {
        console.log(status.value, "how it ended");
        return false;
      }
      if (gameInfo.value.rightLetters.includes(letter)) {
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
          makeGuess(letter);
        }
      }
    });

    const startGame = async () => {
      fetch("http://localhost:3000/game/start-game")
        .then((response) => response.json())
        .then((data) => {
          gameId.value = data.id;
          router.push(`/game/${gameId.value}`);
        })
        .catch((error) => console.error(error));
    };

    async function getGameInfo(id) {
      try {
        const response = await fetch(`http://localhost:3000/game/${+id}`);
        const data = await response.json();

        gameInfo.value = data;
        const rightLetters = Object.keys(data.rightLettersPositions);

        let letters = [];
        for (let i = 0; i < gameInfo.value.word; i++) {
          letters.push("");
        }
        word.value = letters;
        wrongLetters.value = data.wrongLetters.split("");
        correctLetters.value = [...rightLetters];
        guessesLeft.value = data.tries;
        status.value = data.status;

        for (const letter in data.rightLettersPositions) {
          data.rightLettersPositions[letter].map((position) => {
            word.value[position] = letter;
          });
        }
      } catch (err) {
        console.log(err);
      }
    }

    if (gameId.value) {
      onMounted(() => {
        getGameInfo(gameId.value);
      });
    }

    return {
      wrongLetters,
      correctLetters,
      guessesLeft,
      notification,
      status,
      reset,
      manualInputLetter,
      manualInput,
      manualInputChange,
      showNotification,
      changeGameMode,
      manualGameType,
      gameInfo,
      word,
    };
  },
  watch: {
    filter: {
      deep: true,
    },
  },
};
</script>
