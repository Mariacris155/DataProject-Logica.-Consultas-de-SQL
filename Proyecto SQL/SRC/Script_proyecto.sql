--1. Crea el esquema de la BBDD.
--Play al script BBDD_Proyecto descargado y esquema entidad relacion

select *
from "film";


--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

select "title"
from "film"
where "rating" = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
 select "first_name"
from "actor"
where "actor_id" Between  30 and 40;

--4.Obtén las películas cuyo idioma coincide con el idioma original.
select "title"
from "film"
where "language_id" = "original_language_id";

--5. Ordena las películas por duración de forma ascendente.

select "title", "length"
from "film"
order by length ASC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

select "first_name","last_name"
from "actor"
where "last_name" like '%ALLEN%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

select "rating", count (*) as peliculas_totales
from "film"
group by "rating";

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

select "title"
from "film"
where "rating" = 'PG-13' or "length" > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT ROUND(VARIANCE(replacement_cost),2) AS varianza_coste_remplazo
FROM film;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select MAX("length") as duracion_maxima, MIN("length") as duracion_minima
from "film"
;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT p.amount, r.rental_date
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC
OFFSET 2 
LIMIT 1;


--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
select "title"
from "film"
where "rating" not IN ('NC-17' , 'G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select "rating", AVG(length) as duracion_media
from "film"
group by "rating";

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select "title"
from "film"
where "length" > 180;

--15. ¿Cuánto dinero ha generado en total la empresa?
select SUM(amount) as dinero_generado
from "payment"
;

--16. Muestra los 10 clientes con mayor valor de id.
select "customer_id"
from "customer" 
order by "customer_id" desc
limit 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’

SELECT a."first_name", a."last_name"
FROM "actor" AS a
JOIN "film_actor" fa ON a.actor_id = fa.actor_id
JOIN "film" f ON fa.film_id = f.film_id
WHERE f."title" = 'EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos.

select distinct "title"
from "film"
;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name AS categoria, AVG(f.length) AS duracion_media
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?
select AVG("rental_duration") as media_duracion_alquiler
from "film"
;

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat("first_name",' ', "last_name") as nombre_completo_actores
from "actor"
;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente
SELECT DATE("rental_date") AS rental_day, COUNT(*) AS total_rentals
FROM "rental"
GROUP BY DATE("rental_date")
ORDER BY total_rentals DESC;

--24. Encuentra las películas con una duración superior al promedio.
SELECT "title", "length"
FROM "film"
WHERE "length" > (SELECT AVG("length") FROM "film");

--25. Averigua el número de alquileres registrados por mes.
SELECT 
  EXTRACT(MONTH FROM rental_date) AS mes,
  COUNT(*) AS alquileres_totales
FROM "rental"
GROUP BY mes
ORDER BY mes;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT 
  ROUND(AVG("amount"), 2) AS promedio,
  ROUND(STDDEV("amount"), 2) AS desviacion_estandar,
  ROUND(VARIANCE("amount"), 2) AS varianza
FROM "payment";


--27. ¿Qué películas se alquilan por encima del precio medio?

SELECT "title", "rental_rate" 
FROM "film"
WHERE "rental_rate" > (SELECT AVG("rental_rate") FROM "film");

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT "actor_id", COUNT("film_id") AS total_peliculas
FROM "film_actor"
GROUP BY "actor_id"
HAVING COUNT("film_id") > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT 
  f.film_id,
  f.title,
  COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

--30. Obtener los actores y el número de películas en las que ha actuado.

select  "a"."actor_id",
  "a"."first_name",
 "a"."last_name",
  COUNT("f"."film_id") AS total_peliculas
from "actor" "a"
JOIN "film_actor" "f" ON "a"."actor_id" = "f"."actor_id"
GROUP BY "a"."actor_id", "a"."first_name", "a"."last_name"
;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT 
  f.film_id,
  f.title,
  COUNT("a"."actor_id") AS actores_participantes
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT 
  "a"."actor_id",
  "a"."first_name",
 "a"."last_name",
  COUNT("f"."film_id") AS peliculas_participadas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
GROUP BY "a"."actor_id",
  "a"."first_name",
 "a"."last_name"
ORDER BY "a"."first_name";

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT 
f.film_id,
  f.title,
  r.rental_id
FROM film f
 JOIN inventory i ON f.film_id = i.film_id
 JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title;


--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT 
"c"."customer_id",
"c"."first_name",
  "c"."last_name",
  SUM("p"."amount") as total
FROM customer c
 JOIN payment p ON "c"."customer_id" = "p"."customer_id"
 GROUP BY "c"."customer_id"
ORDER BY total DESC
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT  "actor_id", "first_name", "last_name"
 from "actor"
 where upper("first_name") = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT  
       "first_name" AS Nombre, 
       "last_name" AS Apellido
FROM "actor"
order by Nombre;

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT 
       MAX("actor_id"), MIN("actor_id")
FROM "actor"
;

--38. Cuenta cuántos actores hay en la tabla “actor”.

SELECT 
       count("actor_id")
FROM "actor"
;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT  
       "first_name" AS Nombre, 
       "last_name" AS Apellido
FROM "actor"
order by Apellido ASC;

--40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT "film_id",
       "title"
FROM "film"
limit 5
;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT "first_name" AS Nombre, COUNT(*) AS Cantidad
FROM "actor"
GROUP BY "first_name"
ORDER BY Cantidad DESC;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT 
  "r"."rental_id",
  "c"."customer_id",
"c"."first_name",
"c"."last_name"
FROM "rental" "r"
 JOIN "customer" "c" ON "r"."customer_id" = "c"."customer_id"
;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT 
  count("r"."rental_id") as numero_alquileres,
  "c"."customer_id",
"c"."first_name",
"c"."last_name"
FROM "customer" "c"
LEFT JOIN "rental" "r" ON "c"."customer_id" = "r"."customer_id"
GROUP BY "c"."customer_id"
ORDER BY "c"."customer_id"
;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT 
  f.film_id,
  f.title,
  c.category_id,
  c.name AS category_name
FROM film f
CROSS JOIN category c
;

No aporta valor porque las relaciones no son reales. Se ve por ejemplo que para una pelicula se muestran muchas categorias y genera filas que no son utiles por tanto.

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT 
distinct "a"."actor_id",
  "a"."first_name",
   "a"."last_name"
 FROM "actor" "a"
 JOIN "film_actor" "fa" ON "a"."actor_id" = "fa"."actor_id"
 JOIN "film" "f" ON "fa"."film_id" = "f"."film_id"
 JOIN "film_category" "fc" ON "fa"."film_id" = "fc"."film_id"
 JOIN "category" "c" ON "fc"."category_id" = "c"."category_id"
 where "c"."name" = 'Action'
 order by "actor_id"
;

--46. Encuentra todos los actores que no han participado en películas.

SELECT 
  "a"."actor_id",
  "a"."first_name",
  "a"."last_name"
FROM "actor" "a"
LEFT JOIN "film_actor" "fa" ON "a"."actor_id" = "fa"."actor_id"
WHERE "fa"."film_id" IS NULL
ORDER BY "a"."actor_id";


--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT 
  "a"."actor_id",
  "a"."first_name",
  "a"."last_name",
  count(*) AS cantidad_peliculas
FROM "actor" "a"
LEFT JOIN "film_actor" "fa" ON "a"."actor_id" = "fa"."actor_id"
group by "a"."actor_id"
ORDER BY "a"."actor_id";

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas as 
SELECT 
  "a"."actor_id",
  "a"."first_name",
  "a"."last_name",
  count(*) AS cantidad_peliculas
FROM "actor" "a"
LEFT JOIN "film_actor" "fa" ON "a"."actor_id" = "fa"."actor_id"
group by "a"."actor_id"
ORDER BY "a"."actor_id";

--49. Calcula el número total de alquileres realizados por cada cliente.

SELECT 
  count("r"."rental_id") as numero_alquileres,
  "c"."customer_id",
"c"."first_name",
"c"."last_name"
FROM "customer" "c"
JOIN "rental" "r" ON "c"."customer_id" = "r"."customer_id"
GROUP BY "c"."customer_id"
ORDER BY "c"."customer_id"
;

--50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT 
 SUM("f"."length") as duracion_total
 FROM "film" "f"
 JOIN "film_category" "fc" ON "f"."film_id" = "fc"."film_id"
 JOIN "category" "c" ON "fc"."category_id" = "c"."category_id"
 where "c"."name" = 'Action';

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

CREATE TEMP TABLE cliente_rentas_temporal as 
SELECT 
  count("r"."rental_id") as numero_alquileres,
  "c"."customer_id",
"c"."first_name",
"c"."last_name"
FROM "customer" "c"
JOIN "rental" "r" ON "c"."customer_id" = "r"."customer_id"
GROUP BY "c"."customer_id"
ORDER BY "c"."customer_id"
;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMP TABLE peliculas_alquiladas AS
SELECT 
  "f"."film_id",
  "f"."title",
  COUNT("r"."rental_id") AS cantidad_alquileres
FROM "film" "f"
JOIN "inventory" "i" ON "f"."film_id" = "i"."film_id"
JOIN "rental" r ON i."inventory_id" = "r"."inventory_id"
GROUP BY "f"."film_id", f."title"
HAVING COUNT("r"."rental_id") >= 10
ORDER BY cantidad_alquileres DESC;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.


SELECT 
  f.title,
  r.rental_date,
  r.return_date
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
  SELECT customer_id 
  FROM customer 
  WHERE LOWER(first_name) = 'tammy' 
  AND LOWER(last_name) = 'sanders'
)
AND r.return_date IS NULL
ORDER BY f.title;


--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

SELECT 
distinct "a"."actor_id",
  "a"."first_name",
   "a"."last_name"
 FROM "actor" "a"
 JOIN "film_actor" "fa" ON "a"."actor_id" = "fa"."actor_id"
 JOIN "film" "f" ON "fa"."film_id" = "f"."film_id"
 JOIN "film_category" "fc" ON "fa"."film_id" = "fc"."film_id"
 JOIN "category" "c" ON "fc"."category_id" = "c"."category_id"
 where "c"."name" = 'Sci-Fi'
 order by "a"."last_name"
;

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.


SELECT distinct 
  a.first_name,
  a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
  SELECT MIN(r.rental_date)
  FROM film f2
  JOIN inventory i2 ON f2.film_id = i2.film_id
  JOIN rental r ON i2.inventory_id = r.inventory_id
  WHERE LOWER(f2.title) = 'spartacus cheaper'  -- Usamos LOWER para no ser sensibles a mayúsculas
)
ORDER BY a.last_name;

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

SELECT 
distinct "a"."actor_id",
  "a"."first_name",
   "a"."last_name"
 FROM "actor" "a"
 WHERE NOT EXISTS (
  SELECT 1
  FROM "film_actor" "fa"
 JOIN "film" "f" ON "fa"."film_id" = "f"."film_id"
 JOIN "film_category" "fc" ON "fa"."film_id" = "fc"."film_id"
 JOIN "category" "c" ON "fc"."category_id" = "c"."category_id"
 where "c"."name" = 'Music' 
 AND "fa"."actor_id" = "a"."actor_id"
)
 order by "a"."actor_id"
;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT "f"."title"
FROM "film" "f"
JOIN "inventory" "i" ON "f"."film_id" = "i"."film_id"
JOIN "rental" "r" ON "i"."inventory_id" = "r"."inventory_id"
WHERE "r"."return_date" IS NOT NULL
 AND EXTRACT(DAY FROM r.return_date - r.rental_date) > 8
ORDER BY "f"."title";

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

SELECT 
"f"."title"
 FROM "film" "f"
 JOIN "film_category" "fc" ON "f"."film_id" = "fc"."film_id"
 JOIN "category" "c" ON "fc"."category_id" = "c"."category_id"
 where "c"."name" = 'Animation';

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.

SELECT "title"
FROM "film"
WHERE "length" = (
  SELECT "length"
  FROM "film"
   WHERE LOWER("title") = 'dancing fever'
)
ORDER BY "title";

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.


SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  COUNT(DISTINCT f.film_id) AS peliculas_distintas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name;


--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres

SELECT 
  "c"."name" AS categoria,
  COUNT("r"."rental_id") AS total_alquileres
FROM "category" "c"
JOIN "film_category" "fc" ON "c"."category_id" = "fc"."category_id"
JOIN "film" "f" ON "fc"."film_id" = "f"."film_id"
JOIN "inventory" "i" ON "f"."film_id" = "i"."film_id"
JOIN "rental" "r" ON "i"."inventory_id" = "r"."inventory_id"
GROUP BY "c"."name"
ORDER BY total_alquileres DESC;


--62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT 
  "c"."name" AS categoria,
  COUNT("f". "film_id") AS num_pelis
FROM "category" "c"
JOIN "film_category" "fc" ON "c"."category_id" = "fc"."category_id"
JOIN "film" "f" ON "fc"."film_id" = "f"."film_id"
where "f"."release_year" = 2006
group by "c"."name"
;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT 
  "s"."staff_id",
  "s"."first_name",
  "s"."last_name",
  "st"."store_id" as id_tienda
FROM staff s
CROSS JOIN store st
;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT 
  "c"."customer_id",
"c"."first_name",
"c"."last_name",
count("r"."rental_id") as numero_alquileres
FROM "customer" "c"
JOIN "rental" "r" ON "c"."customer_id" = "r"."customer_id"
GROUP BY "c"."customer_id"
ORDER BY "c"."customer_id"
;