select c.class, year(min(b.date)), year(max(b.date)), count(b.date)
from classes c 
left join ships s on c.class = s.class
left join outcomes o on s.name = o.ship
left join battles b on o.battle = b.name
where c.class like 'N%'
group by c.class;