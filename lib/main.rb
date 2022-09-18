class Hangman 
  require 'json'
  attr_accessor :word, :hint, :incorrect_letters, :num_guesses

  def initialize 
    @word = random_word
    @hint = Array.new(@word.length) { '_' }
    @incorrect_letters = []
    @num_guesses = 7
  end

  def to_json
    JSON.dump({
      word: @word,
      hint: @hint,
      incorrect_letters: @incorrect_letters,
      num_guesses: @num_guesses,
    })
  end

  def from_json(string)
    data = JSON.parse string
    @word = data['word']
    @hint = data['hint']
    @incorrect_letters = data['incorrect_letters']
    @num_guesses = data['num_guesses']
  end

  def random_word
    word_list = File.readlines('dictionary.txt')
    word_list = word_list.each(&:strip!).select { |word| word.length.between?(5, 12) }
    word_list[rand(0..word_list.length)]
  end

  def display
    system('clear')
    puts "   |====== HANGMAN =====|"
    puts "Your incorrect guesses are: #{@incorrect_letters.join(' - ').upcase}"
    puts "Number of guesses left: #{@num_guesses}"
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
    load_game?
    until @num_guesses == 0|| game_over?
      display
      letter_guessed = get_guess
      if guess_in_word?(letter_guessed)
        change_hint(letter_guessed)
      else 
        add_incorrect_letter(letter_guessed)
        @num_guesses -= 1
      end
    end
    end_game
  end

  def get_guess
    guess = ""
    until guess.length == 1 
      puts "Please enter just one letter or write 'save' to save the game."
        guess = gets.chomp.downcase
        if guess == "save"
          save_game
          guess = get_guess
        end
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

  def add_incorrect_letter(guess)
    incorrect_letters << guess
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

  def set_filename
    puts "Enter the filename."
    filename = gets.chomp
    if Dir.entries('./savefiles').include?(filename)
      puts "The #{filename} already exists, please choose a different name."
      filename = gets.chomp
    end
    system('clear')
    filename
  end

  def save_game
    puts "Your saved files are:"
    puts Dir.entries('./savefiles')
    filename = set_filename
    File.open("./savefiles/#{filename}", 'w') do |f|
      f.write(to_json)
      f.write('')
    end
    system('clear')
    display
  end

  def load_game?
    puts 'Do you want to load a game?(y/n)'
    input = gets.chomp
    if input.downcase == 'y'
      load_game
    elsif input.downcase == 'n'
      system('clear')
      return
    else
      puts 'Thats not an option'
      load_game?
    end
    system('clear')
  end

  def load_game
    puts "Which file do you want to load?\n\n"
    puts Dir.entries('./savefiles')
    input = gets.chomp
    begin
      file = File.open("./savefiles/#{input}", 'r')
      content = file.read
      from_json(content)
    rescue Errno::ENOENT
      puts 'Only enter existing saves!'
      load_game
    end
  end
end

game = Hangman.new

game.play_game
