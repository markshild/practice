require 'Set'
class WordChainer

  def initialize(file_name)
    @dictionary = Set.new(File.readlines(file_name).map(&:chomp))
  end

  def inspect
  end

  def run(source,target)
    @working_dictionary = @dictionary.dup
    @working_dictionary.keep_if {|word| word.length == source.length}

    @current_words = [source]
    @all_seen_words = {source => nil}
    until @current_words.empty? || @all_seen_words.has_key?(target)
        explore_current_words
    end

    path = build_path(target)
    path << source
    puts path.reverse
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.has_key?(adjacent_word)

        unless new_current_words.include?(adjacent_word)
          new_current_words << adjacent_word
        end

        unless @all_seen_words.has_key?(adjacent_word)
          @all_seen_words[adjacent_word] = current_word
        end

      end
    end
    @current_words = new_current_words
  end

  def adjacent_words(word)
    @working_dictionary.keep_if do |dict_word|
      should_keep = true

      dissimilar = 0
      dict_word.each_char.with_index do |char, index|
        dissimilar += 1 if char != word[index]
        if dissimilar == 2
          should_keep = false
          break
        end
      end

      should_keep = false if dissimilar.zero?
      should_keep
    end
  end

  def build_path(target)
    path = []
    word = target
    until @all_seen_words[word].nil?
      path << word
      word = @all_seen_words[word]
    end

    path
  end

end
