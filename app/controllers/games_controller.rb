# require 'open-uri'
# require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { rand(65..90).chr }
  end

  def score
    # raise
    redirect_to new_path if params[:word] == ''
    letters = params[:letters].split(' ')
    word = params[:word].upcase.chars
    @score = 0
    valid_word = check_dictionary(word)
    word_from_grid = check_word_in_grid(word, letters)
    @message = message(word, letters, word_from_grid, valid_word)
    @score = word.length if valid_word && word_from_grid == true
    session[:score] = session[:score] + @score
  end

  def reset
    session[:score] = 0
    redirect_to new_path
  end

  private

  def check_dictionary(word)
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{word.join}").read
    word_data = JSON.parse(word_serialized)
    word_data['found']
  end

  def check_word_in_grid(word, letters)
    word.each do |l|
      return false if word.count(l) > letters.count(l)
    end
    true
  end

  def message(word, letters, word_from_grid, valid_word)
    if word_from_grid == false
      "Sorry, but #{word.join} can't be built out of #{letters.join(' ')}"
    elsif valid_word == false
      "Sorry, but #{word.join} does not seem to be a valid English word."
    else
      "Congratulations! #{word.join} is a valid English word!"
    end
  end
end
