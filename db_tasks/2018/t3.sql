select s.name, min(m.year), max(m.year), count(*)
from studio s 
join movie m on m.studioname = s.name
where s.name like 'M%'
group by s.name;