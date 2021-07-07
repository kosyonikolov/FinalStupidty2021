-- "Raw" relational algebra solution

select m0.name
from movieexec m0 
where m0.name not in 
(select m1.name
from movieexec m1
join movieexec m2 where m1.networth > m2.networth);