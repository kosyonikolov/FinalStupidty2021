select studio.name, studio.address, AVG(m.length)
from studio left join movie m on studio.name = m.studioname
group by studio.name;