# frozen_string_literal: true

# Base for records from the ratings database
class RatingDbRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection RATINGS_DATABASE
end
