class Game

MAX = 10

  def initialize(guesser, executioner)
    @guesser = guesser
    @executioner = executioner
    @current_word = nil
    @guessed = []
  end

  def play
    init_display
    turn = 0
    until turn == MAX
      d = display
      letter = @guesser.guess(d)
      coords = @executioner.check_guess(letter)
      if coords.nil?
        puts "WRONG!"
        turn +=1
      else
        update_display(letter,coords)
      end
      @guessed << letter
      if won?
        puts "No Hangings Today :("
        display
        break
      end
    end
    puts "Hanged!" unless won?
  end

  def init_display
    length = @executioner.receive_secret_length
    @current_word = Array.new(length)
  end

  def update_display(letter, coords)
    coords.each do |pos|
      @current_word[pos] = letter
    end
  end

  def display
    disp = []
    @current_word.each do |el|
      if el == nil
        disp << '_'
      else
        disp << el
      end
    end
    puts disp.join
    puts "Guessed Letters: #{@guessed}"
    disp
  end

  def won?
    @current_word.none? {|el| el.nil?}
  end

end




class ComputerPlayer

  def initialize(name = 'HAL 9000')
    @name = name
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @guessed = []
    @call = 0
  end

  def inspect
  end

  def pick_secret_word
    @word = @dictionary.sample
    @word
  end

  def receive_secret_length
    pick_secret_word.length
  end

  def guess(d)
    if @call == 0
      @dictionary.select {|word| word.length == d.length}
    end
    table = guess_helper(d)
    table.reject! {|key, value| @guessed.include?(key)}
    letter = table.max_by {|k,v| v}.first
    @call +=1
    @guessed << letter
    letter
  end

  def guess_helper(d)
    wrong_letters = @guessed.reject {|let| d.include?(let)}
    wrong_letters.each do |let|
      @dictionary.reject! {|word| word.split("").include?(let)}
    end

    d.each_with_index do |el,ind|
      if el == '_'
        @dictionary.reject! {|word| d.include?(word[ind])}
      else
        @dictionary.select! {|word| word[ind] == el}
      end
    end

    table = Hash.new {|hash,key| hash[key] = 0}
    @dictionary.each do |word|
      word.split('').each do |letter|
        table[letter] += 1
      end
    end
    table
  end

  def check_guess(letter)
    coord = []
    if @word.include?(letter)
      @word.split('').each_with_index do |el,ind|
        if letter == el
          coord << ind
        end
      end
    else
      return nil
    end
    coord
  end


end


class HumanPlayer

  def initialize(name)
    @name = name
    @guessed_letters = []
  end

  def pick_secret_word

  end

  def receive_secret_length
    puts "Please enter word length"
    gets.chomp.to_i
  end

  def guess(d)
    while true
      puts "Please guess a letter"
      letter = gets.chomp.downcase
      if condition(letter)
        @guessed_letters << letter
        break
      else
        puts "Please pick intelligently..."
      end
    end
    letter
  end

  def condition(letter)
    if letter.length == 1
      if ('a'..'z').include?(letter)
        if !@guessed_letters.include?(letter)
          return true
        end
      end
    end
    false
  end

  def check_guess(letter)
    puts "Is #{letter} in your word? (y/n)"
    answer = gets.chomp.downcase
    if answer == 'y'
      puts "At which position(s) is #{letter}?"
      coords = gets.chomp.split(',').map(&:to_i)
      return coords
    elsif answer == 'n'
      return nil
    end
    nil
  end


end
