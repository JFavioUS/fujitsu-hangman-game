/*
  Warnings:

  - You are about to drop the column `rightGuesses` on the `Game` table. All the data in the column will be lost.
  - You are about to drop the column `wrongGuesses` on the `Game` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Game" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "totalGuesses" INTEGER NOT NULL,
    "word" TEXT NOT NULL,
    "allLetters" TEXT NOT NULL DEFAULT '',
    "rightLetters" TEXT NOT NULL DEFAULT '',
    "wrongLetters" TEXT NOT NULL DEFAULT '',
    "status" TEXT NOT NULL,
    "finished" BOOLEAN NOT NULL DEFAULT false
);
INSERT INTO "new_Game" ("createdAt", "finished", "id", "status", "totalGuesses", "updateAt", "word") SELECT "createdAt", "finished", "id", "status", "totalGuesses", "updateAt", "word" FROM "Game";
DROP TABLE "Game";
ALTER TABLE "new_Game" RENAME TO "Game";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
