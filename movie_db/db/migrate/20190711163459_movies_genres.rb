class MoviesGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :movies_genres do |t|
      t.integer :movieId
      t.integer :genre_id

      t.timestamps
    end
  end
end
