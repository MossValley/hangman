require 'yaml'
require 'erb'
require 'pry'

class Gallows
  attr_accessor :secret_word, :letter_guessed, :display_secret, :wrong_guesses
  attr_reader :dictionary, :counter

  def initialize (secret="", display="_", counter=10, wrong_guesses=[])
    @dictionary = File.readlines "5desk.txt"
    @secret_word = secret
    @letter_guessed = ''
    @display_secret = display
    @counter = counter
    @wrong_guesses = wrong_guesses
    select_secret_word
  end

  def select_secret_word
    if @secret_word == ""
      secret_word_generator
    end
    puts @display_secret
  end

  def save_status
    save_template = File.read "savetemplate.erb"
    save_file = ERB.new save_template
    save_status = save_file.result(binding)
    puts save_status
    save_status
  end

  def player_input
    loop do 
      print "Guess a letter: "
      @letter_guessed = gets.chomp.downcase
      break if @letter_guessed.match?(/[a-z]/) && @letter_guessed.length == 1
      break if @letter_guessed == 'save' || @letter_guessed == 'exit'
      puts "Incorrect input."
    end
    return @letter_guessed
  end

  def player_guess(guess)
    @letter_guessed = guess
    check_guess(@letter_guessed)
    puts @display_secret
    return end_of_game
  end

  private 

  def randomize(dictionary)
    rand(dictionary.length)
  end

  def secret_word_generator
    while @secret_word.length < 5 || @secret_word.length > 12 do
      random_number = randomize(@dictionary)
      @secret_word = @dictionary[random_number].chomp.downcase
    end

    @secret_word
    @display_secret = "_" * @secret_word.length
  end

  def guesses_remaining
    @counter -= 1
    puts "Guesses remainding: #{@counter}"
  end

  def check_guess(letter)
    if @secret_word.include? letter
      update_display(letter)
    else
      puts "Nope, try again"
      update_incorrect(letter)
    end
  end

  def update_display(letter)
    @secret_word.split('').each_with_index do |char, index|
      if @display_secret[index] == '_' && letter == char
        @display_secret[index] = letter
      end
    end
  end

  def update_incorrect(letter)
    if !(@wrong_guesses.include? letter)
      @wrong_guesses.push(letter)
      guesses_remaining
    else 
      puts "Already guessed!"
    end
    puts "Letters guessed: #{@wrong_guesses.join(', ')}"
  end
  
  def end_of_game
    case true
    when @counter == 0
      puts "Game over"
      puts "The word was #{@secret_word}"
      return true
    when !(@display_secret.include? '_')
      puts "You win!"
      return true
    else
      return false
    end
  end

end

class Game
  attr_accessor :game
  def self.init
    start_game
  end

  def self.start_game
    print "Do you wish to load a game? Y/N: "
    response = gets.chomp.downcase
    if response == 'y'
      load_game
    else 
      new_game
    end
  end

  def self.new_game
    @game = Gallows.new
    play_game
  end

  def self.load_game
    if File.exist? 'savegame.txt'
      @game = load_from_yaml('savegame.txt')
      play_game
    else
      puts "There is no saved game to load"
      puts "Starting new game"
      new_game
    end
  end

  def self.save_game
    puts "Saving game"
    game_status = save_as_yaml(@game)
    File.open('savegame.txt', 'w') do |file|
      file.puts game_status
    end
    exit_game
  end

  def self.play_game
    game_over = false
    while game_over == false
      player = @game.player_input
      if player == 'save'
        save_game
      elsif player == 'exit'
        exit_game
      else
        game_over = @game.player_guess(player)
      end
    end
  end
  
  def self.exit_game
    puts "Closing program"
    exit
  end

  def self.save_as_yaml(game)
    YAML.dump( {
      secret_word: game.secret_word,
      display_secret: game.display_secret,
      counter: game.counter,
      wrong_guesses: game.wrong_guesses
    })
  end

  def self.load_from_yaml(file)
    data = YAML.load_file file
    Gallows.new(data[:secret_word], data[:display_secret], data[:counter], data[:wrong_guesses])
  end
end

Game.init