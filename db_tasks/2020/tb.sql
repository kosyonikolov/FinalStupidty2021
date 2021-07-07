select distinct ms.name, year(ms.birthdate), count(s.name)
from moviestar ms 
left join starsin ss on ms.name = ss.starname
left join movie m on m.title = ss.movietitle and m.year = ss.movieyear
left join studio s on m.studioname = s.name
where ms.gender = 'F'
group by ms.name 
having count(ms.name) < 2;