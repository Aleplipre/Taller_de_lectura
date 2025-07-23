/* Base de datos para el registro de los libros leídos en el taler de lectura. */
CREATE DATABASE taller;
USE taller;


/* Creación de tablas: */
-- Libros:
CREATE TABLE libros(
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    fecha_publicacion INT,
    paginas INT,
    dia_en_que_se_comento DATE
);
-- Autores:
CREATE TABLE autores(
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    autor VARCHAR(50) UNIQUE NOT NULL,
    fecha_nacimiento DATE
);
CREATE TABLE libros_autores(
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    UNIQUE (id_libro, id_autor),
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);
-- Géneros:
CREATE TABLE generos(
    id_genero INT PRIMARY KEY AUTO_INCREMENT,
    genero VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE libros_generos(
    id_libro INT NOT NULL,
    id_genero INT NOT NULL,
    UNIQUE (id_libro, id_genero),
    PRIMARY KEY (id_libro, id_genero),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_genero) REFERENCES generos(id_genero)
);
-- Calificaciones:
CREATE TABLE calificaciones(
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    estrellas_1 INT DEFAULT 0,
    estrellas_2 INT DEFAULT 0,
    estrellas_3 INT DEFAULT 0,
    estrellas_4 INT DEFAULT 0,
    estrellas_5 INT DEFAULT 0,
    id_libro INT NOT NULL,
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro)
);


/* Introducción de datos: */
-- Autores:
INSERT INTO autores (autor, fecha_nacimiento)
VALUES ('R. F. Kuang', '1996-05-29'),           -- 1
       ('Katsuhiro Otomo', '1954-04-14'),       -- 2
       ('Arthur C. Clarke', '1917-12-16'),      -- 3
       ('Brandon Sanderson', '1975-12-19'),     -- 4
       ('Frank Herbert', '1920-10-08'),         -- 5
       ('Stephen King', '1947-09-21'),          -- 6
       ('Nieves Concostrina', '1961-08-01'),    -- 7
       ('Susanna Clarke', '1959-11-01'),        -- 8
       ('Terry Pratchett', '1948-04-28');       -- 9
-- Géneros:
INSERT INTO generos (genero)
VALUES ('Fantasía'),        -- 1
       ('Young adult'),     -- 2
       ('Ciencia ficción'), -- 3
       ('Aventuras'),       -- 4
       ('Drama'),           -- 5
       ('Terror'),          -- 6
       ('Suspense'),        -- 7
       ('Crimen'),          -- 8
       ('Histórica'),       -- 9
       ('Humor'),           -- 10
       ('Divulgación');     -- 11
-- Libros:
INSERT INTO libros (titulo, fecha_publicacion, paginas, dia_en_que_se_comento)
VALUES ('La guerra de la amapola', 2018, 646, '2024-12-29'),                                                            -- 1
       ('Akira', 1990, NULL, '2021-06-09'),                                                                             -- 2
       ('2001: Una odisea espacial', 1968, 240, '2021-07-21'),                                                          -- 3
       ('El imperio final', 2006, 690, '2021-09-21'),                                                                   -- 4
       ('Dune', 1965, 658, '2021-12-01'),                                                                               -- 5
       ('La milla verde', 1996, 444, '2025-02-16'),                                                                     -- 6
       ('Mr. Mercedes', 2014, 437, '2022-01-07'),                                                                       -- 7
       ('Pretérito imperfecto: Historias del mundo desde el año de la pera hasta ya mismo', 2018, 451, '2022-02-15'),   -- 8
       ('Jonathan Strange y el Señor Norrell', 2004, 795, '2022-04-28'),                                                -- 9
       ('La ciencia de Mundodisco', 1999, 416, '2022-06-16'),                                                           -- 10
       ('Cita con Rama', 1973, 448, '2025-04-08');                                                                      -- 11
-- SELECT * FROM libros;                        -- Ver id_libro.
-- SELECT * FROM autores;                       -- Ver id_autor.
INSERT INTO libros_autores (id_libro, id_autor)
VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 6), (8, 7), (9, 8), (10, 9), (11, 3);
-- SELECT * FROM generos ORDER BY id_genero;    -- Ver id_genero.
INSERT INTO libros_generos (id_libro, id_genero)
VALUES (1, 1), (1, 2), (2, 3), (3, 3), (4, 1), (4, 2), (5, 3), (5, 4), (6, 1), (6, 5), (7, 6), (7, 7), (7, 8), (8, 9),
       (8, 10), (9, 1), (9, 9), (10, 11), (10, 10), (10, 1), (11, 3);
-- Calificaciones:
INSERT INTO calificaciones (id_libro, estrellas_1, estrellas_2, estrellas_3, estrellas_4, estrellas_5)
VALUES (1, 0, 3, 6, 1, 1), (2, 0, 0, 1, 2, 1), (3, 0, 1, 1, 1, 1), (4, 1, 2, 4, 0, 0), (5, 0, 0, 2, 4, 3),
       (6, 0, 0, 1, 6, 1), (7, 0, 1, 0, 2, 0), (8, 0, 1, 2, 0, 0), (9, 0, 0, 1, 0, 0), (10, 1, 2, 0, 0, 0),
       (11, 0, 2, 3, 1, 0);

/* Visualización de datos: */
CREATE VIEW info_libros AS
SELECT 
    l.titulo,
    GROUP_CONCAT(DISTINCT a.autor ORDER BY a.autor SEPARATOR ', ') AS autores,
    l.fecha_publicacion,
    GROUP_CONCAT(DISTINCT g.genero ORDER BY g.genero SEPARATOR ', ') AS generos,
    l.paginas,
    l.dia_en_que_se_comento,
    MAX(c.estrellas_1) AS estrellas_1,
    MAX(c.estrellas_2) AS estrellas_2,
    MAX(c.estrellas_3) AS estrellas_3,
    MAX(c.estrellas_4) AS estrellas_4,
    MAX(c.estrellas_5) AS estrellas_5
FROM libros l
LEFT JOIN libros_autores la ON l.id_libro = la.id_libro
LEFT JOIN autores a ON la.id_autor = a.id_autor
LEFT JOIN libros_generos lg ON l.id_libro = lg.id_libro
LEFT JOIN generos g ON lg.id_genero = g.id_genero
LEFT JOIN calificaciones c ON l.id_libro = c.id_libro
GROUP BY l.id_libro;
-- SELECT * FROM info_libros ORDER BY dia_en_que_se_comento;

/* Exportar datos: */
-- Con encabezado.
(SELECT 'Título', 'Autoría', 'Año de publicación', 'Géneros', 'Páginas', 'Día comentado', '1*', '2*', '3*', '4*', '5*')
UNION SELECT titulo, autores, fecha_publicacion, generos, paginas, dia_en_que_se_comento, estrellas_1, estrellas_2,
estrellas_3, estrellas_4, estrellas_5 FROM info_libros
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/libros_comentados.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
