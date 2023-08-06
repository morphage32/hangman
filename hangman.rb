class Puzzle
  attr_reader :strikes
  attr_accessor :seed, :previous_letters

  def initialize()
    @previous_letters = []
    @strikes = 0
    @seed
    @secret_word
    @puzzle_letters
  end

  def save_game()
    File.write("savegame.txt", "#{@seed}\n#{previous_letters.join}")
    puts "See you next time!"
  end

  def get_secret_word()
    wordlist = File.open("google-10000-english-no-swears.txt", "r")
    line_number = 1

    wordlist.each do |line|
      if line_number == @seed
        @secret_word = line.chomp
        break
      end
      line_number += 1
    end

    wordlist.close
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

    if correct == 0
      @strikes += 1
    end

    return correct

  end

  def show_letters()
    @puzzle_letters.each do |slot|
      print slot + " "
    end
  end

  def add_previous(letter)
    @previous_letters.push(letter)
  end

  def show_previous()
    print "Wrong letters: "
    @previous_letters.each do |letter|
      unless @secret_word.include?(letter)
        print letter + " "
      end
    end
  end

  def check_previous(letter)
    if @previous_letters.include?(letter)
      return true
    end
    return false
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

class Hangman

  def initialize()
    @hangman_grid = []
    @hangman_grid[0] = [" "," "," "," "," ","-","-","-","-","-","-","-","-",
    "-","-","-","+"]
    @hangman_grid[1] = [" "," "," "," ", " ", "|"," "," "," "," "," "," "," ",
    " "," "," ","|"]
    i = 2
    while i < 7 do
      @hangman_grid[i] = [" "," "," "," "," "," "," "," "," "," "," "," "," "," ",
      " "," ","|"]
      i += 1
    end
    @hangman_grid[7] = [" "," "," "," "," "," "," "," "," "," "," "," "," "," ",
    " ","/","|","\\"]
    @hangman_grid[8] = Array.new(26, "-")
  end

  def show_hangman()
    i = 0
    @hangman_grid.length.times do
      puts @hangman_grid[i].join
      i += 1
    end
  end

  def add_strike(strike_number)
    case strike_number
    when 1
      @hangman_grid[2][5] = "O"
    when 2
      @hangman_grid[3][5] = "|"
      @hangman_grid[4][5] = "|"
    when 3
      @hangman_grid[5][4] = "/"
    when 4
      @hangman_grid[5][6] = "\\"
    when 5
      @hangman_grid[3][3] = "-"
      @hangman_grid[3][4] = "-"
    when 6
      @hangman_grid[3][6] = "-"
      @hangman_grid[3][7] = "-"
    end
  end

end

def main_game()
  current_puzzle = Puzzle.new()
  guy = Hangman.new()
  victory = false
  response = 'X'

  unless File.empty?("savegame.txt")
    until response == 'Y' || response == 'N' do
      puts "You have a saved game, would you like to resume? ('Y' for yes, 'N' for no): "
      response = gets.chomp.upcase
    end
  end

  if response == 'Y'
    line_number = 1
    gamedata = File.open("savegame.txt", "r")
    gamedata.each do |line|
      case line_number
      when 1
        current_puzzle.seed = line.chomp.to_i
      when 2
        current_puzzle.previous_letters = line.chomp.split("")
      end
      line_number += 1
    end

    gamedata.close
    current_puzzle.get_secret_word
    current_puzzle.previous_letters.each do |letter|
      if current_puzzle.check_guess(letter) == 0
        guy.add_strike(current_puzzle.strikes)
      end
    end

  else
    current_puzzle.seed = rand(1..10000)
    current_puzzle.get_secret_word
  end

  while current_puzzle.strikes < 6 && victory == false do
    guy.show_hangman
    puts
    current_puzzle.show_previous
    puts "\n\n"
    current_puzzle.show_letters
    player_guess = ""

    until player_guess.length == 1 &&
      (player_guess.ord > 96 && player_guess.ord < 123) do
        puts "\n\nGuess a letter or type 'save' to save and quit: "
        player_guess = gets.downcase.chomp

        if player_guess == 'save'
          current_puzzle.save_game
          return
        end

        if current_puzzle.check_previous(player_guess) == true
          puts "Sorry, '#{player_guess}' has already been guessed. Try again."
          player_guess = ""
        end
    end

    current_puzzle.add_previous(player_guess)

    if current_puzzle.check_guess(player_guess) == 0
      puts "\nWRONG!"
      guy.add_strike(current_puzzle.strikes)
    else
      puts "\nCORRECT!"
    end

    victory = current_puzzle.endgame_check

  end

  File.write("savegame.txt", "")

  if victory == true
    puts "WINNER! :)"
  else
    puts "GAME OVER! :("
  end

  guy.show_hangman
  current_puzzle.show_secret_word

end

main_game
