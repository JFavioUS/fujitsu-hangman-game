/*
  Warnings:

  - Added the required column `status` to the `Game` table without a default value. This is not possible if the table is not empty.

*/
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
    "status" TEXT NOT NULL
);
INSERT INTO "new_Game" ("createdAt", "id", "rightGuesses", "totalGuesses", "updateAt", "word", "wrongGuesses") SELECT "createdAt", "id", "rightGuesses", "totalGuesses", "updateAt", "word", "wrongGuesses" FROM "Game";
DROP TABLE "Game";
ALTER TABLE "new_Game" RENAME TO "Game";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
