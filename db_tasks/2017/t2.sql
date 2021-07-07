SELECT name, sum(length)
FROM movieexec 
JOIN movie ON producerc = cert
group by name
having min(year) < 1980;