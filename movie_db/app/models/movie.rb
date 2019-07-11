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
  scope :for_show, ->(id) { select(SHOW_FIELDS).where(imdbId: id).first }

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
end