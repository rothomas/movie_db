# frozen_string_literal: true

# A rating record
class Rating < RatingDbRecord
  scope :for_movie, ->(id) { where(movieId: id) }
  scope :only_rating, -> { select(:rating) }
  scope :all_ratings, ->(id) { for_movie(id).only_rating }

  def self.average_rating(movie_id)
    ratings = all_ratings(movie_id).map(&:rating)
    (ratings.reduce(&:+) / ratings.size.to_f).round(2)
  end
end