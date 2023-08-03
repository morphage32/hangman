class Puzzle

  def initialize()
    wordlist = File.open("google-10000-english-no-swears.txt", "r")
    random_line = rand(1..10000)
    line_number = 1
    @secret_word
    
    wordlist.each do |line|
      if line_number == random_line
        @secret_word = line
        break
      end
      line_number += 1
    end

  end

  def show_secret_word()
    puts @secret_word
  end

end

secret_puzzle = Puzzle.new()
secret_puzzle.show_secret_word()

