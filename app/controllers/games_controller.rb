# require 'open-uri'
# require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    if params[:attempt]
      @attempt = params[:attempt]
    end

    # On récupère le hidden field tag via params avec la clé "name" qu'on lui a définie,
    # car params est la façon d'accéder au body d'une requête POST
    @letters_in_score_string = params[:grid]
    @letters_in_score_array = @letters_in_score_string.split(" ")

    if @attempt.upcase.chars.all? { |letter_trial| @attempt.downcase.count(letter_trial) <= @letters_in_score_array.count(letter_trial) }
      response = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}")
      json = JSON.parse(response.read)
      if json['found']
        @results = "Congratulations, #{@attempt} is a valid word. Your score is #{@attempt.length * 10} points"
      else
        @results = "Sorry, but #{@attempt} does not seem to be a valid English word. No points for you!"
      end
    else
      @results = "Oops, it seems that #{@attempt} cannot be built from #{@letters_in_score_string}. No points for you!"
    end
  end

  # On a le droit de créer d'autres méthodes dans le Controller que les méthodes appelées dans le Router
  # La Best practice c'est de les mettre dans private
  # Par conséquent, je pouvais réutiliser toutes les petites méthodes intermédiaires de la solution du cours de Parsing

  # private
end
