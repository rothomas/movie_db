# Movie DB

This project implements a simple movie database as an exercise. I've made no functional changes to the code, but added this 
README and made a couple of minor changes for GitHub distribution.
Here is how to get it to run:

 - Project was built against Ruby 2.6.3.
 - Run `bundle install`.
 - Drop your `movies.db` and `ratings.db` into the `/db` directory.
 - Run `rails db:migrate` to build the local database (used for genres).
 - Run `rails s`
 
 ### Alternative: Docker
 If you prefer, you can also use the included `Dockerfile`.  This will build a
 `ruby:2.6.3-alpine` image and perform bundler and migration steps. 
 
 - Drop your `movies.db` and `ratings.db` into the `/db` directory.
 - Run `docker build -t movie_db .` in the root to build a docker image.
 - Run `docker run -it --rm -p 3000:3000 movie_db` to start the server.
 
 ## Notes
 - There currently aren't any unit tests.  I started with acceptance tests, which
 are found as a separate project, using RSpec and HTTParty, in the `/acceptance` 
 directory.  Run them while the server is up.  You can configure the tests with
 `HOST` and `PORT` environment variables, but it defaults to `localhost:3000`.
 - Tests are implemented for the features I worked on at home (up through
 query-by-year).  The query-by-genre part was what we did in pairing, but the tests
 would look very similar to the by-year tests.
 - The genre tables need to be populated ahead of time from the denormalized column in
 the movie table.  Do this by hitting `http://localhost:3000/extract`.  It will run for
 a while, extracting the genres from each movie and building up the genre and join tables.
 
 ## API
 - `/extract` - Utility endpoint for pulling all genre data into tables.
 Probably better as a rake task, but I haven't written one in a while and was timeboxed.
 
 
 - `/movies` - Return the first page of all movies (page size is 50).
 - `/movies?page=2` - Return the second page of movies.  Will return an empty list if you pass the end.
 - `/movies?year=1973` - Returns the first page of all movies released in 1973.
 - `/movies?genre=Action` - Returns the first page of all Action movies.
 - `/movies/<imdbId>` - Show details for a single movie.  Used imdbId because, by the spec, 
 movieId was not exposed in the index.
 
 
 - `/genres` - Return a list of all known genres.
 - `/genres/<genreId>` - Return the genre name and a link to the movies-by-genre endpoint for the genre.