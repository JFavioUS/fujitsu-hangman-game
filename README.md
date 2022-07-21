# fujitsu-hangman-game

This is a hangman game coded with Vue3 composition API on the frontend, and NodeJS with Express on the backend, the game information is persistent in a SQLite database that is read and write with the Prisma ORM. The game has two views, a welcome view with only a single button to start a new game and the game view where the player can make guesses, there are two ways to play the game, one automatic, that we can use our keyboard and guess quickly, or the manual way, where we can use an input field to guess the letter.

Only the game information persists in the database, the file with all the words to guess is in a static folder in a json file.

## How to install

Copy the repository and in each folder (backend, frontend) do a npm install, after that we can run in two process the "npm run serve" for the frontend project, and "npm run dev" for the backend side. The SQLite database is already in the project files as it does not contains any sensible information.

## Why Vue3

At the start of the project Vue3, specially with the composition API, was a bit of a challenge, as I haven't use the framework in some time, but once I got some things running it got easier, and faster to develop. There is some duplicated code, but it was going to take time to refactorize the code, and I'm certain that I'm going to work on some details of this code in the future to keep improving in Vue. As it doesn't have so many components I goruped them all in a single folder for accessing. And most of the core functionality is in the setup() method of the view page, and then it is passed in as props to the components. There's only one file used as a util that contains the functionality of the event for the "automatic" game mode.

## Why NodeJs with Express

Node is my favorite backend language and express is a great help to start a project easily and quickly, I structured the files in controllers for the client side requests, and services that is where all the business logic goes.
