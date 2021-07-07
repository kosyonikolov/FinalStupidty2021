select distinct studio.name, studio.address
from studio join movie m1 on studio.name = m1.studioname
join movie m2 on studio.name = m2.studioname
where m1.incolor = 'Y' and m2.incolor = 'N'
order by studio.address asc;