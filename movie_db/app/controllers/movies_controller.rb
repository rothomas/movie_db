# frozen_string_literal: true

# Support querying movies database
class MoviesController < ApplicationController

  def index
    query = validate_index_params
    @movies = Movie.for_index
                   .by_year(query)
                   .by_genre(query)
                   .paginated(query)
                   .map(&:index_representation)
    render json: @movies.to_json
  end

  def show
    id = params.require(:id)
    @movie = Movie.for_show(id)
    if @movie.is_a?(Movie)
      render json: @movie.show_representation.to_json
    else
      render status: 204
    end
  end

  def extract
    Movie.extract_all_genres
    render status: 204
  end

  private

  def validate_index_params
    query = params.permit(:year, :sort, :page, :genre)
    unless query[:year].nil? || query[:year].match?(/^[0-9]{4}$/)
      render status: 400, body: "Invalid year: #{query[:year]}"
    end
    unless query[:sort].nil? || %w[asc desc].include?(query[:sort])
      render status: 400, body: "Invalid sort order: #{query[:sort]}"
    end
    unless query[:page].nil? || query[:page].match?(/^[1-9][0-9]*/)
      render status: 400, body: "Invalid page number: #{query[:sort]}"
    end
    query
  end

end