# frozen_string_literal: true
require 'date'

# A movie record
class Movie < MovieDbRecord
  PAGE_SIZE = 50

  INDEX_FIELDS = %I[
    movieId
    imdbId
    title
    genres
    releaseDate
    budget
  ].freeze

  SHOW_FIELDS = %I[
    movieId
    imdbId
    title
    overview
    releaseDate
    budget
    runtime
    genres
    language
    productionCompanies
  ].freeze

  scope :for_index, -> { select(INDEX_FIELDS) }
  scope :by_year, lambda { |query|
    year = query[:year]
    direction = query[:sort] || 'asc'
    if year.nil?
      all
    else
      where(releaseDate: year_range(year)).order(releaseDate: direction)
    end
  }
  scope :for_show, ->(id) { select(SHOW_FIELDS).where(imdbId: id).all.first }

  scope :by_genre, lambda { |query|
    genre_name = query[:genre]
    if genre_name.nil?
      all
    else
      genre = Genre.find_by(name: genre_name)
      if genre.is_a?(Genre)
        movie_ids = MoviesGenres.where(genre_id: genre.id).map(&:movieId)
        where(movieId: movie_ids)
      end
    end
  }

  # PAGINATION
  scope :page_limit, -> { limit(PAGE_SIZE) }
  scope :page_offset, lambda { |query|
    offset(((query[:page] || 1).to_i - 1) * PAGE_SIZE)
  }
  scope :paginated, ->(query) { page_limit.page_offset(query) }

  def self.year_range(year)
    start = Date.new(year.to_i)
    start..start.end_of_year
  end

  def index_representation
    {
        imdbId: imdbId,
        title: title,
        genres: extract_names(genres),
        releaseDate: releaseDate,
        budget: "$#{budget}"
    }
  end

  def show_representation
    index_representation.merge(
      overview: overview,
      runtime: runtime,
      rating: Rating.average_rating(movieId),
      language: language,
      productionCompanies: extract_names(productionCompanies)
    )
  end

  def extract_names(field)
    JSON.parse(field).map { |f| f['name'] }
  end

  def extract_genres
    genre_list = JSON.parse(genres)
    genre_list.each do |genre|
      record = Genre.find_or_create_by!(genre)
      MoviesGenres.find_or_create_by!(movieId: movieId, genre_id: record.id)
    end
  end

  def self.extract_all_genres
    all.each(&:extract_genres)
  end


end