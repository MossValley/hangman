
class Game
  def initialize
    @dictionary = File.readlines "5desk.txt"
    @secret_word = ''
    @letter_guessed = ''
    @display_secret = '_'
    @counter = 10
    @incorrect_guesses = []
  end

  def randomize(dictionary)
    rand(dictionary.length)
  end

  def secret_word_generator
    while @secret_word.length < 5 || @secret_word.length > 12 do
      random_number = randomize(@dictionary)
      @secret_word = @dictionary[random_number].chomp.downcase
    end

    @secret_word
  end

  def guesses_remaining
    @counter -= 1
    puts "Turns remainding: #{@counter}"
  end

  def player_guess
    loop do 
      print "Guess a letter: "
      @letter_guessed = gets.chomp.downcase
      break if @letter_guessed.match?(/[a-z]/) && @letter_guessed.length == 1
      puts "Incorrect input."
    end
    check_guess(@letter_guessed)
    puts @display_secret
  end

  def check_guess(letter)
    if @secret_word.include? letter
      update_display(letter)
    else
      puts "Nope, try again"
      update_incorrect(letter)
      guesses_remaining
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
    if !(@incorrect_guesses.include? letter)
      @incorrect_guesses.push(letter)
    end
    puts "Letters guessed: #{@incorrect_guesses.join(', ')}"
  end

  def play_game
    secret_word_generator
    @display_secret = "_" * @secret_word.length
    puts @display_secret
    game_over = false
    while game_over == false
      case true
      when @counter == 0
        puts "Game over"
        game_over = true
      when !(@display_secret.include? '_')
        puts "You win!"
        game_over = true
      else
        player_guess
        game_over = false
      end
    end
  end
end

class Player
  def initialize 
    @counter = 10
  end

  def guesses_remaining
    @counter -= 1
  end

  def guess_letter
  end
end

new_word = Game.new
word = new_word.secret_word_generator
p word
new_word.play_game
