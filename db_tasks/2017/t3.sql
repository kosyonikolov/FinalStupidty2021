SELECT starname, title, name, networth
FROM starsin 
JOIN movie ON movietitle=title AND movieyear=year
JOIN (SELECT cert, networth, name
      FROM movieexec
      WHERE networth = (select max(networth) from movieexec limit 1)) t
      ON t.cert = movie.producerc;