class Genre < ApplicationRecord

  def index_representation
    { id: id, name: name }
  end

  def show_representation
    {
      genre: name,
      movies: url_for(action: 'index', controller: '/movies', genre: name)
    }
  end

end
