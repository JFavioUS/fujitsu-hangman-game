const express = require("express");
const cors = require("cors");

const game = require("./controllers/game");

const app = express();

app.use(cors());
app.use(express.json());
app.use("/game", game);

app.get("/", (req, res) => {
  res.status(200);
  res.json({ hello: "world" });
});

module.exports = app;
