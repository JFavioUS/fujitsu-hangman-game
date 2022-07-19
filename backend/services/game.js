const data = require("../data/englishWords.json");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

// ------ START: This functions would go to a different utils file ------
function gameStatus(game, fLetters) {
  if (fLetters.wrong.length >= +game.totalGuesses) return "lose";
  if (fLetters.expected.every((letter) => fLetters.right.includes(letter)))
    return "win";

  return "";
}

function formatLetters({ word, wrongLetters, rightLetters, allLetters }) {
  return {
    expected: word.split(""),
    wrong: wrongLetters.split(""),
    right: rightLetters.split(""),
    all: allLetters.split(""),
  };
}

function validateInput(letterGuessed) {
  if (letterGuessed.length > 1 || letterGuessed.length <= 0) return false;
  if (letterGuessed.charAt() < 65 || letterGuessed.charAt > 90) return false;

  return true;
}
// ------ END: This functions would go to a different utils file ------

async function startGame() {
  const { words } = data;
  const TOTAL_GUESSES = 10;
  const randomIndex = Math.floor(Math.random() * words.length);

  const randomWord = words[randomIndex];

  const game = await prisma.game.create({
    data: {
      totalGuesses: TOTAL_GUESSES,
      word: randomWord,
      rightLetters: "",
      wrongLetters: "",
      allLetters: "",
      status: "active",
    },
    select: {
      id: true,
      word: true,
      status: true,
      totalGuesses: true,
      tries: true,
      finished: true,
    },
  });

  return game;
}

async function getGame(id) {
  const game = await prisma.game.findFirst({
    where: { id: +id },
    select: {
      id: true,
      word: true,
      status: true,
      allLetters: true,
      wrongLetters: true,
      rightLetters: true,
      totalGuesses: true,
      tries: true,
      finished: true,
    },
  });

  return game;
}

async function playGame(game, playInfo) {
  const fLetters = formatLetters(game);
  const letterGuessed = playInfo.letterGuessed.toLowerCase();

  const status = gameStatus(game, fLetters);

  if (status === "lose" || status === "win") {
    await prisma.game.update({
      where: { id: game.id },
      data: {
        status: status,
        finished: true,
      },
    });

    return {
      status,
      message: `This game finished in a ${status}`,
      error: "game-finished",
    };
  }

  if (!validateInput(letterGuessed)) {
    return {
      status,
      message: "Invalid input",
      error: "invalid-input",
    };
  }

  if (fLetters.all.includes(letterGuessed)) {
    return {
      status,
      message: "already guessed",
      error: "already-guessed",
    };
  }

  fLetters.all.push(letterGuessed);
  const allLetters = fLetters.all.join("");
  const rightLetters = fLetters.all
    .filter((letter) => fLetters.expected.includes(letter))
    .join("");
  const wrongLetters = fLetters.all
    .filter((letter) => !fLetters.expected.includes(letter))
    .join("");
  const tries = game.totalGuesses - wrongLetters.length;

  const updatedGame = await prisma.game.update({
    where: { id: game.id },
    data: { allLetters, rightLetters, wrongLetters, tries },
    select: {
      id: true,
      word: true,
      status: true,
      allLetters: true,
      wrongLetters: true,
      rightLetters: true,
      totalGuesses: true,
      tries: true,
      finished: true,
    },
  });

  return updatedGame;
}

module.exports = {
  startGame,
  getGame,
  playGame,
};
