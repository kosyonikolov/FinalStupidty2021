select b.name
from battles b 
join outcomes o on b.name = o.battle 
join ships s on o.ship = s.name 
left join classes c on s.class = c.class and c.type='bb'
left join classes c1 on s.class = c1.class and c1.type='bc'
group by b.name
having count(c.type) > count(c1.type);