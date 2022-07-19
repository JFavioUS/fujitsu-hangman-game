-- CreateTable
CREATE TABLE "Game" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "totalGuesses" INTEGER NOT NULL,
    "word" TEXT NOT NULL,
    "rightGuesses" TEXT NOT NULL,
    "wrongGuesses" TEXT NOT NULL
);
