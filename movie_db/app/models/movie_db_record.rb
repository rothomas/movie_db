# frozen_string_literal: true

# Base for records from the movies database
class MovieDbRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection MOVIES_DATABASE
end
