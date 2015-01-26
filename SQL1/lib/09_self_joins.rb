# == Schema Information
#
# Table name: stops
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: route
#
#  num         :string      not null, primary key
#  company     :string       not null, primary key
#  pos         :integer      not null, primary key
#  stop        :integer

require_relative './sqlzoo.rb'

def num_stops
  # How many stops are in the database?
  execute(<<-SQL)
    SELECT
      COUNT(*)
    FROM
      stops
  SQL
end

def craiglockhart_id
  # Find the id value for the stop 'Craiglockhart'.
  execute(<<-SQL)
    SELECT
      id
    FROM
      stops
    WHERE
      name = 'Craiglockhart'
  SQL
end

def lrt_stops
  # Give the id and the name for the stops on the '4' 'LRT' service.
  execute(<<-SQL)
    SELECT
      s.id, s.name
    FROM
      stops s
    INNER JOIN
      route r
    ON
      s.id = r.stop
    WHERE
      r.company = 'LRT' AND r.num = '4'
  SQL
end

def connecting_routes
  # Do a query that shows the number of routes that visit either London Road
  # (149) or Craiglockhart (53). Run the query and notice the two services
  # that link these stops have a count of 2. Add a HAVING clause to restrict
  # the output to these two routes.
  execute(<<-SQL)
    SELECT
      company, num, COUNT(*)
    FROM
      route
    WHERE
      stop IN (53, 149)
    GROUP BY
      company, num
    -- HAVING
    --   COUNT(*) = 2

  SQL
end

def cl_to_lr
  # Execute a self join and observe that b.stop gives all the places
  # you can get to from Craiglockhart (53), without changing routes.
  # DON'T DO THIS PART:
  # Change the query so that it shows the services from Craiglockhart to London Road.
  execute(<<-SQL)
    SELECT
      r1.company, r1.num, r1.stop, r2.stop
    FROM
      route r1
    INNER JOIN
      route r2
    ON
      r1.company = r2.company AND r1.num = r2.num AND r1.stop = 53
  SQL
end

def cl_to_lr_by_name
  # The query shown is similar to the previous one, however by joining two
  # copies of the stops table we can refer to stops by name rather than by
  # number. Change the query so that the services between 'Craiglockhart' and
  # 'London Road' are shown. If you are tired of these places try
  # 'Fairmilehead' against 'Tollcross'
  execute(<<-SQL)
    SELECT
      r1.company, r1.num, s1.name, s2.name
    FROM
      route r1
    INNER JOIN
      route r2
    ON
      r1.company = r2.company AND r1.num = r2.num AND r1.stop = 53
    INNER JOIN
      stops s1
    ON
      r1.stop = s1.id
    INNER JOIN
      stops s2
    ON
      r2.stop = s2.id
  SQL
end

def haymarket_and_leith
  # Give a list of all the services which connect stops 115 and 137
  # ('Haymarket' and 'Leith')
  execute(<<-SQL)
    SELECT DISTINCT
      r1.company, r1.num
    FROM
      route r1
    INNER JOIN
      route r2
    ON
      r1.company = r2.company AND r1.num = r2.num AND r1.stop = 115 AND r2.stop = 137
  SQL
end

def craiglockhart_and_tollcross
  # Give a list of the services which connect the stops 'Craiglockhart' and
  # 'Tollcross'
  execute(<<-SQL)
    SELECT DISTINCT
      r1.company, r1.num
    FROM
      route r1
    INNER JOIN
      route r2
    ON
      r1.company = r2.company AND r1.num = r2.num
        AND r1.stop = (
          SELECT
            id
          FROM
            stops
          WHERE
            name = 'Craiglockhart'
        ) AND r2.stop = (
          SELECT
            id
          FROM
            stops
          WHERE
            name = 'Tollcross'
        )
  SQL
end

def start_at_craiglockhart
  # Give a distinct list of the stops which may be reached from 'Craiglockhart'
  # by taking one bus, including 'Craiglockhart' itself. Include the company
  # and bus no. of the relevant services.
  execute(<<-SQL)
    SELECT DISTINCT
      s.name, r1.company, r1.num
    FROM
      stops s
    INNER JOIN
      route r1
    ON
      s.id = r1.stop
    INNER JOIN
      route r2
    ON
      r1.company = r2.company AND r1.num = r2.num
      AND r2.stop = (
          SELECT
            id
          FROM
            stops
          WHERE
            name = 'Craiglockhart'
        )

  SQL
end

def craiglockhart_to_sighthill
  # Find the routes involving two buses that can go from Craiglockhart to
  # Sighthill. Show the bus no. and company for the first bus, the name of the
  # stop for the transfer, and the bus no. and company for the second bus.
  execute(<<-SQL)
    SELECT DISTINCT
      start.num, start.company, transfer.name, finish.num, finish.company
    FROM
      route start
    JOIN
      route AS to_transfer ON
        (start.company = to_transfer.company AND start.num = to_transfer.num)
    JOIN
      stops AS transfer ON
        (to_transfer.stop = transfer.id)
    JOIN
      route AS from_transfer ON
        (transfer.id = from_transfer.stop)
    JOIN
      route AS finish ON
        (from_transfer.company = finish.company AND from_transfer.num = finish.num)
    WHERE
      start.stop = (
        SELECT
          id
        FROM
          stops
        WHERE
          name = 'Craiglockhart'
      ) AND finish.stop = (
        SELECT
          id
        FROM
          stops
        WHERE
          name = 'Sighthill'
      )
  SQL
end
