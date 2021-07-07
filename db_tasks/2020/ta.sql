select distinct ms.name, ms.birthdate
from moviestar ms 
join starsin ss on ms.name = ss.starname
join movie m on m.title = ss.movietitle and m.year = ss.movieyear
where m.incolor = 'Y' and ms.name not like '%Jr.%';