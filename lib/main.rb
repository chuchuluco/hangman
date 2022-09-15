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
    word_list.each(&:strip!).select { |word| word.length.between?(5, 12) }
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
    display
    letter_guessed = get_guess
    p letter_guessed
    puts guess_in_word?(letter_guessed)
  end

  def get_guess
    guess = ""
    until guess.length == 1 
      puts "Please enter just one letter"
      guess = gets.chomp
    end
    guess
  end
  
  def guess_in_word?(guess)
    return true if @word.include?(guess)
    return false unless @word.include?(guess)
  end

end

game = Hangman.new 
puts game.word

game.play_game
