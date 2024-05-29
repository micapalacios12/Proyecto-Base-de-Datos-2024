set search_path = cines;

-- a) Devolver actores que solo figuran en una sola película.
	
-- b) Listar las personas que han sido actores y directores.
select distinct dni as actuo_y_dirigio 
from (select dni from protagonizo union select dni from reparto) as actores 
inner join dirige using (dni);

-- c) Listar los cines con la cantidad total de butacas totales.
select nombre_cine, sum(cant_butaca) as cant_butaca_totales 
from sala 
group by nombre_cine;

-- d) Definir consultas propias (no menos de tres), donde por lo menos una utilice subconsultas.

-- 1) Listar las personas que actuaron en mas de dos peliculas
select distinct actuaron.dni as actuo_2_o_mas from (select * from protagonizo  union select * from reparto) as actuaron, 
(select * from protagonizo union select * from reparto) as actuaron2 
where (actuaron.dni = actuaron2.dni and actuaron.id_pelicula != actuaron2.id_pelicula);


-- 2) Mostrar la pelicula (id_pelicula, titulo_espanol) mas larga 
select p.id_pelicula, p.titulo_espanol 
from pelicula p 
inner join ( select  max (duracion) as max_du from pelicula ) as max_duracion 
on p.duracion = max_duracion.max_du; 


