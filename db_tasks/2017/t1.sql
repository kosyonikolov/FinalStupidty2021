SELECT studioname, title, year 
FROM movie m 
WHERE year = (SELECT max(year) 
              FROM movie WHERE movie.studioname = m.studioname);