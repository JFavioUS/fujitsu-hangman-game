const app = require("./app");

const PORT = 3000;

app.listen(PORT, (error) => {
  if (!error)
    console.log(
      `Server is Successfully Running, and app is listening on PORT ${PORT}`
    );
  else console.log(`Error occurred, server can't start ${error}`);
});
