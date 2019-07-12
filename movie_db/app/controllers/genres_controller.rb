# frozen_string_literal: true

# Support querying movies database
class GenresController < ApplicationController

  def index
    render json: Genre.all.map(&:index_representation).to_json
  end

  def show
    genre = Genre.find(params[:id])
    if genre.is_a?(Genre)
      render json: {
        genre: genre.name,
        movies: url_for(action: :index, controller: :movies, genre: genre.name)
      }
    end
  end

end