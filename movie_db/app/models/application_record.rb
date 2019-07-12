# frozen_string_literal: true

# Base for records from the movies database
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
