class Hangman 
  attr_accessor :word, :hint, :incorrect_letters, :num_guesses

  def initialize 
    @word = random_word
    @hint = Array.new(@word.length) { '_' }
    @incorrect_letters = []
    @num_guesses = 7
  end

  def random_word
    word_list = IO.readlines('dictionary.txt')
    word_list = word_list.each(&:strip!).select { |word| word.length.between?(5, 12) }
    word_list[rand(0..word_list.length)]
  end

  def display
    system('clear')
    puts "   |====== HANGMAN =====|"
    puts "Your incorrect guesses are: #{@incorrect_letters.join(' - ').upcase}"
    puts "\n"
    puts "\n"
    puts "\n"
    puts "    " + @hint.join(' ')
    puts "\n"
    puts "Choose a letter!"
    puts "\n"
    puts "\n"
  end

  def play_game
    until @num_guesses == 0|| game_over?
      display
      puts @word
      letter_guessed = get_guess
      if guess_in_word?(letter_guessed)
        change_hint(letter_guessed)
      else 
        @num_guesses -= 1
      end
    end
    end_game
  end

  def get_guess
    guess = ""
    until guess.length == 1 
      puts "Please enter just one letter"
      guess = gets.chomp.downcase
    end
    guess
  end
  
  def guess_in_word?(guess)
    return true if @word.include?(guess)
    return false unless @word.include?(guess)
  end

  def change_hint(guess) 
    @word.split(//).each_with_index do |char, index|
      @hint[index] = guess if char == guess
    end
  end

  def game_over?
    if @hint.include?('_')
      false
    else
      true
    end
  end

  def end_game
    system('clear')
    if @num_guesses.zero?
      puts "Oh no you Died! The Word was #{@word}"
    end
    puts "You won! Nice!" if game_over?
  end

end

game = Hangman.new

game.play_game
