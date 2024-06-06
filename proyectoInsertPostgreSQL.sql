SET SEARCH_PATH = CINES;

--Insertando datos en PELICULA
INSERT INTO PELICULA (TITULO_ORIGINAL, TITULO_ESPANOL, TITULO_DISTRIB, FECHA_ESTRENO, RESUMEN, DURACION, CALIFICACION, IDIOMA_ORIG, URL,GENERO,ANIO_PRODUC) VALUES
('Who Am I', 'Ningún sistema es seguro', 'Ningún sistema es seguro', '29-05-2024', 'Dos hackers que crean el equipo informático CLAY', '1:42:00', '+18 años', 'Aleman', 'https://ningun_sistma_es_seguro' , 'suspenso', 2023),
('Maleficent', 'Malefica', 'Malefica', '03-06-2024', 'Motivada por la venganza, Maléfica echa una terrible maldición sobre la hija del rey, Aurora.', '1:39:00', 'Apta todo público', 'Ingles', 'https://malefica', 'Fantasia', 2024),
('Paranormal Activity', 'Actividad paranormal', 'Actividad paranormal', '06-06-24', 'Una joven pareja conformada por Katie y Micah, es atormentada por un ente paranormal en su propia casa', '1:26:00', '+15 años', 'Ingles', 'https://actividad_paranormal', 'Terror', 2023);

--Insertando datos en PERSONA
INSERT INTO PERSONA (DNI, NOMBRE, NACIONALIDAD) VALUES
(1111, 'Juan', 'Aleman'),
(2222, 'Gaston', 'Estado Unidense'),
(3333, 'Miranda', 'Frances'),
(4444, 'Valeri', 'Aleman'),
(5555, 'Ashly', 'Estado Unidense'),
(6666, 'Tom', 'Estado Unidense'),
(7777, 'Jesus', 'Estado Unidense'),
(8888, 'Malena', 'Aleman'),
(9999, 'Virginia', 'Frances');

--Insertando datos en CINE
INSERT INTO CINE (NOMBRE_CINE, TELEFONO, DIRECCION) VALUES
('Cine del paseo','358564321', 'Sobremonte 80'),
('Cine marconi', '358429800', 'Avenida Granadero 200');

--Insertando datos en SALA
INSERT INTO SALA (CANT_BUTACA, NOMBRE_CINE) VALUES
(100, 'Cine del paseo'),
(150, 'Cine del paseo'),
(80, 'Cine marconi');

--Insertando datos en FUNCION
INSERT INTO FUNCION (ID_PELICULA, ID_SALA, FECHA, HORA_COMIENZO, HORA_FINALIZACION) VALUES
(1, 1, '29-05-2024', '19:30:00', '21:00:00'), 
(2, 3, '06-06-2024', '19:00:00', '20:45:00'),
(3, 3, '06-06-2024', '21:00:00', '22:45:00'),
(3, 2, '08-06-2024', '20:00:00', '21:42:00'),
(2, 1, '08-06-2024', '18:00:00', '19:45:00');	

--Insertando los paises de la PELICULA
INSERT INTO PAISES_PELICULA (ID_PELICULA, NOMBRE_PAIS) VALUES
(1, 'Alemania'),
(1, 'Estados Unidos'),
(2, 'Estados Unidos'),
(3, 'Estados Unidos');


INSERT INTO DIRIGE (ID_PELICULA, DNI) VALUES
(1, 1111),
(2, 1111),
(3, 6666);


INSERT INTO PROTAGONIZO (ID_PELICULA, DNI) VALUES
(1, 2222),
(2, 5555),
(3, 9999),
(2, 1111),
(3, 3333);


INSERT INTO REPARTO (ID_PELICULA, DNI) VALUES 
(1, 4444),
(2, 7777),
(3, 8888),
(3, 6666),
(1, 5555);

