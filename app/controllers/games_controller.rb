require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def new
    grid = generate_grid(10)
    @letters = grid.join(" ")
  end

  def score
    @letters = params[:letters].split
    @word = (params[:choice] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
