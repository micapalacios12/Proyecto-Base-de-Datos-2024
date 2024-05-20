-- Schema

CREATE SCHEMA cine;

SET search_path = cine;

-- Dominio
CREATE DOMAIN enteroPositivo AS INT
DEFAULT 0
	CHECK (VALUE > 0); -- Restriccion


-- Tablas
CREATE TABLE Pelicula (
	id_pelicula SERIAL PRIMARY KEY,
	titulo_original VARCHAR(255) NOT NULL,
	titulo_espanol VARCHAR(255),
	titulo_distrib VARCHAR(255),
	fecha_estreno DATE,
	resumen TEXT,
	duracion enteroPositivo,
	calificacion VARCHAR(10),
	idioma_orig VARCHAR(50),
	url VARCHAR(255),
	genero VARCHAR(50),
	anio_produc enteroPositivo
);

-- Atributo multivaluado

CREATE TABLE Pais (
	id_pais SERIAL PRIMARY KEY, 
	nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Paises_pelicula (
	id_pelicula INT NOT NULL,
    id_pais INT NOT NULL,
    PRIMARY KEY (id_pelicula, id_pais),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais) ON DELETE CASCADE
);



CREATE TABLE Persona (
	dni enteroPositivo NOT NULL PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL, 
	nacionalidad VARCHAR(50),
	cant_pelicula enteroPositivo
);

CREATE TABLE Cine (
	nombre_cine VARCHAR(45) NOT NULL PRIMARY KEY,
	telefono enteroPositivo,
	direccion varchar(45)
);

CREATE TABLE Sala (
	id_sala enteroPositivo NOT NULL PRIMARY KEY,
	cant_butaca enteroPositivo,
	nombre_cine varchar(45),
	CONSTRAINT fkcine FOREIGN KEY (nombre_cine) references cine (nombre_cine)
);

CREATE TABLE Funcion (
	id_funcion enteroPositivo NOT NULL PRIMARY KEY, 
	id_pelicula enteroPositivo,
	id_sala enteroPositivo,
	fecha DATE,
	hora_comienzo TIME,
	hora_finalizacion TIME,
	CONSTRAINT fkpelicula FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
	CONSTRAINT fksala FOREIGN KEY (id_sala) REFERENCES Sala (id_sala),
	CONSTRAINT control_hora CHECK (hora_comienzo < hora_finalizacion) -- Restricción
);

CREATE TABLE Auditoria (
	id_pelicula enteroPositivo NOT NULL PRIMARY KEY,
	fecha_estreno_anterior DATE,
	nueva_fecha_estreno DATE,
	fecha_del_cambio DATE
);

-- Trigger

CREATE FUNCTION Auditoria_fecha()
	RETURNS TRIGGER AS '
	BEGIN
		IF fecha_estreno_anterior IS DISTINCT FROM nueva_fecha_estreno THEN
			INSERT INTO Auditoria (id_pelicula, fecha_estreno_anterior, nueva_fecha_estreno, fecha_del_cambio)
			VALUES (OLD.id_pelicula, OLD.fecha_estreno_anterior, NEW.nueva_fecha_estreno, CURRENT_DATE);
    END IF;
    return NEW;
END;' language plpgsql;


CREATE TRIGGER trigger_Auditoria
	AFTER UPDATE ON Pelicula
	FOR EACH ROW
	EXECUTE FUNCTION Auditoria_fecha();

-- Relaciones
CREATE TABLE Dirige (
	id_pelicula INT NOT NULL,
	dni enteroPositivo NOT NULL, 
	PRIMARY KEY (id_pelicula, dni),
	FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
	FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Protagonizo (
    id_pelicula INT NOT NULL,
    dni enteroPositivo NOT NULL,
    PRIMARY KEY (id_pelicula, dni),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Reparto (
    id_pelicula INT NOT NULL,
    dni enteroPositivo NOT NULL,
    PRIMARY KEY (id_pelicula, dni),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (dni) REFERENCES Persona(dni)
);

-- Despues tendriamos que preguntarle a los profes que cosas tendriamos que ver con cascade, set null y esas cosas . Y tambien en la parte de que los codigos deben ser generdos automaticamente lo tenesmos que hacer con un tigger o le podemos poner el tipo serial a esos atributos. Y tambien preguntar sobre la cant_pelicula como se hace un atriuto calculado

--Consideraciones Adicionales

    Cascade y Set Null: Debes decidir si quieres usar ON DELETE CASCADE o ON DELETE SET NULL en tus claves foráneas, dependiendo de cómo deseas manejar la eliminación de registros relacionados. Esto puede discutirse con tus profesores para obtener una guía más específica.

    Generación Automática de Códigos: Para la generación automática de códigos, puedes usar el tipo de datos SERIAL o BIGSERIAL. Alternativamente, puedes crear un trigger para manejar esta funcionalidad. Usar SERIAL es generalmente más sencillo y directo.

    Atributos Calculados: Para cant_pelicula como un atributo calculado (por ejemplo, el número de películas en las que una persona ha participado), puedes usar una vista o una columna generada (GENERATED ALWAYS AS).
    
    -- Claves foráneas con CASCADE
ALTER TABLE sala
ADD CONSTRAINT fkcine FOREIGN KEY (nombre_cine) REFERENCES cine (nombre_cine) ON DELETE CASCADE;

ALTER TABLE funcion
ADD CONSTRAINT fkpelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula) ON DELETE CASCADE;

-- Generación automática de IDs usando SERIAL
CREATE TABLE persona (
    dni SERIAL PRIMARY KEY,
    nombre VARCHAR(45),
    nacionalidad VARCHAR(45),
    cant_pelicula INTEGER
);

-- Atributo calculado usando una vista
CREATE VIEW cant_peliculas_view AS
SELECT dni, COUNT(*) AS cant_pelicula
FROM protagonizo
GROUP BY dni;

