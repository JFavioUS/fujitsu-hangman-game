const express = require("express");
const router = express.Router();

const gameService = require("../services/game");

router.get("/start-game", async function (req, res) {
  const response = await gameService.startGame();

  const responseObject = {
    ...response,
    word: response.word.length,
  };

  res.send(responseObject);
});

router.get("/:id", async function (req, res) {
  const { id } = req.params;

  const game = await gameService.getGame(id);

  const responseObject = {
    ...game,
    word: game?.word?.length,
  };

  res.send(responseObject);
});

router.post("/:id", async function (req, res) {
  const { id } = req.params;
  const playInfo = req.body;

  const game = await gameService.getGame(id);
  const updatedGameResponse = await gameService.playGame(game, playInfo);

  if (!updatedGameResponse.finished && !updatedGameResponse.error) {
    const responseObject = {
      ...updatedGameResponse,
      word: updatedGameResponse.word.length,
    };

    return res.send(responseObject);
  }

  res.send(updatedGameResponse);
});

module.exports = router;
