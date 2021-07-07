-- Subquery solution

select m0.name
from movieexec m0 
where m0.networth in 
(select min(networth) from movieexec);