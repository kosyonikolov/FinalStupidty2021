SELECT name, title, year
FROM movie JOIN movieexec ON producerc=cert
WHERE cert = ANY (SELECT producerc
                   FROM movie
                   WHERE title='star Wars');