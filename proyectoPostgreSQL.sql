-- Schema
CREATE SCHEMA CINE;

SET
	SEARCH_PATH = CINE;

-- Dominio
CREATE DOMAIN ENTEROPOSITIVO AS INT DEFAULT 0 CHECK (VALUE > 0);

-- Dominio para calificación
CREATE DOMAIN calificacionTipo AS VARCHAR(20)
CHECK (VALUE IN ('Apta todo público', '+13 años', '+15 años', '+18 años'));

-- Tablas
CREATE TABLE PELICULA (
	ID_PELICULA SERIAL PRIMARY KEY,
	TITULO_ORIGINAL VARCHAR(255) NOT NULL,
	TITULO_ESPANOL VARCHAR(255),
	TITULO_DISTRIB VARCHAR(255),
	FECHA_ESTRENO DATE,
	RESUMEN TEXT,
	DURACION ENTEROPOSITIVO,
	CALIFICACION calificacionTipo,
	IDIOMA_ORIG VARCHAR(50),
	URL VARCHAR(255),
	GENERO VARCHAR(50),
	ANIO_PRODUC ENTEROPOSITIVO
);

-- Atributo multivaluado
CREATE TABLE PAISES_PELICULA (
	ID_PELICULA INT NOT NULL,
	ID_PAIS INT NOT NULL,
	PRIMARY KEY (ID_PELICULA, ID_PAIS),
	FOREIGN KEY (ID_PELICULA) REFERENCES PELICULA (ID_PELICULA) ON DELETE CASCADE,
	FOREIGN KEY (ID_PAIS) REFERENCES PAIS (ID_PAIS) ON DELETE CASCADE
);

CREATE TABLE PERSONA (
	DNI ENTEROPOSITIVO NOT NULL PRIMARY KEY,
	NOMBRE VARCHAR(255) NOT NULL,
	NACIONALIDAD VARCHAR(50),
	CANT_PELICULA ENTEROPOSITIVO
);

CREATE TABLE CINE (
	NOMBRE_CINE VARCHAR(45) NOT NULL PRIMARY KEY,
	TELEFONO ENTEROPOSITIVO,
	DIRECCION VARCHAR(45)
);

CREATE TABLE SALA (
	ID_SALA ENTEROPOSITIVO NOT NULL PRIMARY KEY,
	CANT_BUTACA ENTEROPOSITIVO,
	NOMBRE_CINE VARCHAR(45),
	CONSTRAINT FKCINE FOREIGN KEY (NOMBRE_CINE) REFERENCES CINE (NOMBRE_CINE)
);

CREATE TABLE FUNCION (
	ID_FUNCION ENTEROPOSITIVO NOT NULL PRIMARY KEY,
	ID_PELICULA ENTEROPOSITIVO,
	ID_SALA ENTEROPOSITIVO,
	FECHA DATE,
	HORA_COMIENZO TIME,
	HORA_FINALIZACION TIME,
	CONSTRAINT FKPELICULA FOREIGN KEY (ID_PELICULA) REFERENCES PELICULA (ID_PELICULA),
	CONSTRAINT FKSALA FOREIGN KEY (ID_SALA) REFERENCES SALA (ID_SALA),
	CONSTRAINT CONTROL_HORA CHECK (HORA_COMIENZO < HORA_FINALIZACION) -- Restricción
);

CREATE TABLE AUDITORIA (
	ID_PELICULA ENTEROPOSITIVO NOT NULL PRIMARY KEY,
	FECHA_ESTRENO_ANTERIOR DATE,
	NUEVA_FECHA_ESTRENO DATE,
	FECHA_DEL_CAMBIO DATE
);

-- Trigger
CREATE FUNCTION AUDITORIA_FECHA () RETURNS TRIGGER AS '
	BEGIN
		IF fecha_estreno_anterior IS DISTINCT FROM nueva_fecha_estreno THEN
			INSERT INTO Auditoria (id_pelicula, fecha_estreno_anterior, nueva_fecha_estreno, fecha_del_cambio)
			VALUES (OLD.id_pelicula, OLD.fecha_estreno_anterior, NEW.nueva_fecha_estreno, CURRENT_DATE);
    END IF;
    return NEW;
END;' LANGUAGE PLPGSQL;

CREATE TRIGGER TRIGGER_AUDITORIA
AFTER
UPDATE ON PELICULA FOR EACH ROW
EXECUTE FUNCTION AUDITORIA_FECHA ();

-- Relaciones
CREATE TABLE DIRIGE (
	ID_PELICULA INT NOT NULL,
	DNI ENTEROPOSITIVO NOT NULL,
	PRIMARY KEY (ID_PELICULA, DNI),
	FOREIGN KEY (ID_PELICULA) REFERENCES PELICULA (ID_PELICULA),
	FOREIGN KEY (DNI) REFERENCES PERSONA (DNI)
);

CREATE TABLE PROTAGONIZO (
	ID_PELICULA INT NOT NULL,
	DNI ENTEROPOSITIVO NOT NULL,
	PRIMARY KEY (ID_PELICULA, DNI),
	FOREIGN KEY (ID_PELICULA) REFERENCES PELICULA (ID_PELICULA),
	FOREIGN KEY (DNI) REFERENCES PERSONA (DNI)
);

CREATE TABLE REPARTO (
	ID_PELICULA INT NOT NULL,
	DNI ENTEROPOSITIVO NOT NULL,
	PRIMARY KEY (ID_PELICULA, DNI),
	FOREIGN KEY (ID_PELICULA) REFERENCES PELICULA (ID_PELICULA),
	FOREIGN KEY (DNI) REFERENCES PERSONA (DNI)
);

-- Despues tendriamos que preguntarle a los profes que cosas tendriamos que ver con cascade, set null y esas cosas . Y tambien en la parte de que los codigos deben ser generdos automaticamente lo tenesmos que hacer con un tigger o le podemos poner el tipo serial a esos atributos. Y tambien preguntar sobre la cant_pelicula como se hace un atriuto calculado
--Consideraciones Adicionales
--    Cascade y Set Null: Debes decidir si quieres usar ON DELETE CASCADE o ON DELETE SET NULL en tus claves foráneas, dependiendo de cómo deseas manejar la eliminación de registros relacionados. Esto puede discutirse con tus profesores para obtener una guía más específica.
--    Generación Automática de Códigos: Para la generación automática de códigos, puedes usar el tipo de datos SERIAL o BIGSERIAL. Alternativamente, puedes crear un trigger para manejar esta funcionalidad. Usar SERIAL es generalmente más sencillo y directo.
--    Atributos Calculados: Para cant_pelicula como un atributo calculado (por ejemplo, el número de películas en las que una persona ha participado), puedes usar una vista o una columna generada (GENERATED ALWAYS AS).
-- Claves foráneas con CASCADE
--ALTER TABLE sala
--ADD CONSTRAINT fkcine FOREIGN KEY (nombre_cine) REFERENCES cine (nombre_cine) ON DELETE CASCADE;
--ALTER TABLE funcion
--ADD CONSTRAINT fkpelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula) ON DELETE CASCADE;
-- Generación automática de IDs usando SERIAL
--CREATE TABLE persona (
--dni SERIAL PRIMARY KEY,
--nombre VARCHAR(45),
--nacionalidad VARCHAR(45),
--cant_pelicula INTEGER
--);
-- Atributo calculado usando una vista
--CREATE VIEW cant_peliculas_view AS
--SELECT dni, COUNT(*) AS cant_pelicula
--FROM protagonizo
--GROUP BY dni;