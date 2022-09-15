class Hangman 
  attr_accesor :word, :hint, :incorrect_letters, :num_guesses

  def initialize 
    @word = get_word
    @dictionary = File.readlines('dictionary.txt')
    @hint = display_hint 
    @incorrect_letters = []
    @num_guesses = 7
  end
end
