select b.name
from classes c 
join ships s on c.class = s.class
join outcomes o on s.name = o.ship
join battles b on o.battle = b.name
group by b.name
having count(case when c.type = 'bb' then 1 else null end) > count(case when c.type = 'bc' then 1 else null end);