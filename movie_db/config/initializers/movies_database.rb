# frozen_string_literal: true

MOVIES_DATABASE = YAML.load_file(
  File.join(Rails.root, 'config', 'movies_database.yml')
)[Rails.env.to_s]