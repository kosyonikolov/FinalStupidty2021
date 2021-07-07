select ms.name, count(*)
from moviestar ms 
join starsin si on ms.name = si.starname
group by ms.name
having count(*) >=
(
    select max(mm1.cnt) from
    (
        select count(*) as cnt
        from moviestar ms1 
        join starsin si1 on ms1.name = si1.starname
        group by ms1.name
    ) mm1
);