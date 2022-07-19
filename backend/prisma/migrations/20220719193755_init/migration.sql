-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Game" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "totalGuesses" INTEGER NOT NULL,
    "tries" INTEGER NOT NULL DEFAULT 10,
    "word" TEXT NOT NULL,
    "allLetters" TEXT NOT NULL DEFAULT '',
    "rightLetters" TEXT NOT NULL DEFAULT '',
    "wrongLetters" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "finished" BOOLEAN NOT NULL DEFAULT false
);
INSERT INTO "new_Game" ("allLetters", "createdAt", "finished", "id", "rightLetters", "status", "totalGuesses", "updateAt", "word", "wrongLetters") SELECT "allLetters", "createdAt", "finished", "id", "rightLetters", "status", "totalGuesses", "updateAt", "word", "wrongLetters" FROM "Game";
DROP TABLE "Game";
ALTER TABLE "new_Game" RENAME TO "Game";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
