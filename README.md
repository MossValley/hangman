A terminal game of "hangman"  made as part of The Odin Project's Ruby Programming course: https://www.theodinproject.com/courses/ruby-programming/lessons/file-i-o-and-serialization-ruby-programming


The computer selects a word between 5 and 12 characters from a dictionary txt file and the player has 10 guesses to guess the word.

Dictionary file obtained from scrapmaker.com's word list: https://www.scrapmaker.com/data/wordlists/twelve-dicts/5desk.txt


**Features**
* Can save game by typing 'save'
* If opting to load game will load last saved game
* Can exit game by typing 'exit'
* Game will keep track of guesses and show which letters guessed - won't count letters already guessed again
* If guesses remaining becomes zero will inform player of loss and show anwer

**Extra features to add?**
* Drawing an actual stick man for incorrect guesses
* Player choosing length of word range and/or number of guesses
* Multiple saved games?