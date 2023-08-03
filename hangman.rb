class Puzzle

  def initialize()
    wordlist = File.open("google-10000-english-no-swears.txt", "r")
    random_line = rand(1..10000)
    line_number = 1
    
    wordlist.each do |line|
      if line_number == random_line
        @secret_word = line.chomp
        break
      end
      line_number += 1
    end

    @puzzle_letters = Array.new(@secret_word.length, "_")

  end

  def check_guess(guess_letter)
    correct = 0
    index = 0

    @secret_word.each_char do |secret_letter|
      if secret_letter == guess_letter
        correct += 1
        @puzzle_letters[index] = guess_letter
      end

    index += 1

    end

    return correct

  end

  def show_letters()
    @puzzle_letters.each do |slot|
      print slot + " "
    end
  end

  def endgame_check()
    @puzzle_letters.each do |slot|
      if slot == "_"
        return false
      end
    end
    return true
  end

  def show_secret_word()
    puts "The secret word was " + @secret_word.upcase
  end

end

def main_game()
  current_puzzle = Puzzle.new()
  strikes = 0
  victory = false

  while strikes < 6 && victory == false do
    current_puzzle.show_letters
    player_guess = ""

    until player_guess.length == 1 &&
          (player_guess.ord > 96 && player_guess.ord < 123) do
            puts "\n\nGuess a letter: "
            player_guess = gets.downcase.chomp
    end

    if current_puzzle.check_guess(player_guess) == 0
      puts "\nWRONG!"
      strikes += 1
    else
      puts "\nCORRECT!"
    end

    victory = current_puzzle.endgame_check

  end

  if victory == true
    puts "WINNER! :)"
  else
    puts "GAME OVER! :("
  end

  current_puzzle.show_secret_word

end

main_game
