# == Schema Information
#
# Table name: actor
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movie
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director    :integer
#
# Table name: casting
#
#  movieid     :integer      not null, primary key
#  actorid     :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movie
    JOIN
      casting ON movie.id = casting.movieid
    JOIN
      actor ON casting.actorid = actor.id
    WHERE
      actor.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    SELECT
      title
    FROM
      movie
    JOIN
      casting ON movie.id = casting.movieid
    JOIN
      actor ON casting.actorid = actor.id
    WHERE
      actor.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
    SELECT
      title
    FROM
      movie
    JOIN
      casting ON movie.id = casting.movieid
    JOIN
      actor ON casting.actorid = actor.id
    WHERE
      actor.name = 'Harrison Ford' AND casting.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    SELECT
      m.title, a.name
    FROM
      movie m
    JOIN
      casting c ON m.id = c.movieid
    JOIN
      actor a ON c.actorid = a.id
    WHERE
      m.yr = 1962 AND c.ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    SELECT
      m.yr, COUNT(m.title)
    FROM
      movie m
    JOIN
      casting c ON m.id = c.movieid
    JOIN
      actor a ON c.actorid = a.id
    WHERE
      a.name = 'John Travolta'
    GROUP BY
      m.yr
    HAVING
      COUNT(m.title) >= 2

  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
    SELECT
      m.title, a.name
    FROM
      movie m
    JOIN
      casting c ON m.id = c.movieid
    JOIN
      actor a ON c.actorid = a.id
    WHERE
      c.ord = 1 AND m.id IN (
                      SELECT
                        m2.id
                      FROM
                        movie m2
                      JOIN
                        casting c2 ON m2.id = c2.movieid
                      JOIN
                        actor a2 ON a2.id = c2.actorid
                      WHERE
                        a2.name = 'Julie Andrews')
    SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT
      a1.name
    FROM
      (SELECT
        a.name, COUNT(*) num_starring_roles
      FROM
        actor a
      JOIN
        casting c ON a.id = c.actorid
      GROUP BY
        a.name, c.ord
      HAVING
        c.ord = 1) a1
    WHERE
      a1.num_starring_roles >=15
    ORDER BY
      a1.name

  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast.
  execute(<<-SQL)
    SELECT
      m.title, COUNT(*) cast_size
    FROM
      movie m
    JOIN
      casting c ON m.id = c.movieid
    GROUP BY
      m.title, m.yr
    HAVING
      m.yr = 1978
    ORDER BY
      cast_size DESC
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have worked with 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT DISTINCT
      a.name
    FROM
      actor a
    JOIN
      casting c ON c.actorid = a.id
    JOIN
      movie m ON c.movieid = m.id
    WHERE
      a.name != 'Art Garfunkel' AND m.id IN (
        SELECT
          m2.id
        FROM
          movie m2
        JOIN
          casting c2 ON c2.movieid = m2.id
        JOIN
          actor a2 ON a2.id = c2.actorid
        WHERE
          a2.name = 'Art Garfunkel'
        )
  SQL
end
