-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Game" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "totalGuesses" INTEGER NOT NULL,
    "word" TEXT NOT NULL,
    "rightGuesses" TEXT NOT NULL,
    "wrongGuesses" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "finished" BOOLEAN NOT NULL DEFAULT false
);
INSERT INTO "new_Game" ("createdAt", "id", "rightGuesses", "status", "totalGuesses", "updateAt", "word", "wrongGuesses") SELECT "createdAt", "id", "rightGuesses", "status", "totalGuesses", "updateAt", "word", "wrongGuesses" FROM "Game";
DROP TABLE "Game";
ALTER TABLE "new_Game" RENAME TO "Game";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
