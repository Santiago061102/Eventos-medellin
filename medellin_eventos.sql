-- ============================================================
--  BASE DE DATOS: Eventos Culturales y de Entretenimiento
--  Ciudad: Medellín, Colombia  |  Proyecto: ¿Qué Hay en Medellín? 🌸
--  Fecha: Abril 2026
--  CUMPLE: 7 tablas, PKs, FKs (≥3), Normalización 3NF,
--          INSERT ≥10 registros/tabla, SELECT/WHERE/ORDER BY/
--          GROUP BY/JOIN/Subconsulta, CREATE VIEW, UPDATE, DELETE
-- ============================================================

CREATE DATABASE IF NOT EXISTS medellin_eventos
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medellin_eventos;

-- ============================================================
--  TABLA 1: LUGARES  (11 registros)
-- ============================================================
CREATE TABLE lugares (
    id_lugar               INT AUTO_INCREMENT PRIMARY KEY,
    nombre                 VARCHAR(150) NOT NULL,
    tipo_lugar             ENUM('teatro','estadio','parque','centro_cultural',
                                'galeria','bar','auditorio','salon','plaza','otro') NOT NULL,
    direccion              VARCHAR(255),
    barrio                 VARCHAR(100),
    comuna                 VARCHAR(100),
    ciudad                 VARCHAR(100) DEFAULT 'Medellín',
    capacidad_total        INT,
    tiene_parqueadero      BOOLEAN DEFAULT FALSE,
    accesible_discapacidad BOOLEAN DEFAULT FALSE,
    latitud                DECIMAL(10,8),
    longitud               DECIMAL(11,8),
    fecha_registro         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO lugares (nombre, tipo_lugar, direccion, barrio, comuna, capacidad_total, tiene_parqueadero, accesible_discapacidad, latitud, longitud) VALUES
('Estadio Atanasio Girardot',              'estadio',         'Cra 74 #48-200',              'Laureles',     'Laureles',      45000, TRUE,  TRUE,  6.25637, -75.59197),
('Plaza de Toros La Macarena',             'plaza',           'Cra 44 #44-57',               'La Candelaria','La Candelaria', 10000, TRUE,  FALSE, 6.23648, -75.56888),
('Teatro Metropolitano José Gutiérrez',    'teatro',          'Calle 41 #57-30',             'Arrobleda',    'La América',     1800, TRUE,  TRUE,  6.24744, -75.57248),
('Teatro Universidad de Medellín',         'teatro',          'Cra 87 #30-65',               'Laureles',     'Laureles',       3000, TRUE,  TRUE,  6.23879, -75.60043),
('La Pascasia',                            'bar',             'Calle 10 #41-42',             'El Poblado',   'El Poblado',     1200, FALSE, FALSE, 6.20896, -75.56804),
('Cubo Universo Creativo',                 'salon',           'Cra 52 #18Sur-90',            'Guayabal',     'Guayabal',        800, TRUE,  FALSE, 6.20100, -75.58900),
('Diamante de Béisbol Luis A. Villegas',   'estadio',         'Cra 80 #33-200',              'Robledo',      'Robledo',        8000, TRUE,  TRUE,  6.26900, -75.60700),
('Corporación Cultural Ciudad Frecuencia', 'centro_cultural', 'Calle 30 #65-10',             'La América',   'La América',     3000, FALSE, FALSE, 6.24200, -75.59100),
('Teatro La Enseñanza',                    'teatro',          'Calle 54 #49-20',             'La Candelaria','La Candelaria',   400, FALSE, TRUE,  6.25300, -75.56900),
('Biblioteca Pública Piloto de Medellín',  'centro_cultural', 'Calle 44 #52-60',             'La Candelaria','La Candelaria',  5000, FALSE, TRUE,  6.24900, -75.57100),
('Parque de los Deseos',                   'parque',          'Cra 52 #71-117',              'Aranjuez',     'Aranjuez',       5000, FALSE, TRUE,  6.27200, -75.56800);
-- Total: 11 registros ✓


-- ============================================================
--  TABLA 2: ORGANIZADORES  (10 registros ✓)
-- ============================================================
CREATE TABLE organizadores (
    id_organizador    INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(150) NOT NULL,
    tipo_organizacion ENUM('empresa_privada','entidad_publica','colectivo',
                           'fundacion','universidad','persona_natural') NOT NULL,
    email             VARCHAR(150),
    telefono          VARCHAR(20),
    sitio_web         VARCHAR(255),
    instagram         VARCHAR(100),
    verificado        BOOLEAN DEFAULT FALSE,
    fecha_registro    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO organizadores (nombre, tipo_organizacion, email, sitio_web, instagram, verificado) VALUES
('Alcaldía de Medellín – Secretaría de Cultura', 'entidad_publica',  'cultura@medellin.gov.co',  'www.medellin.gov.co',   '@culturamedellin',  TRUE),
('Move Concerts Colombia',                        'empresa_privada',  'info@moveconcerts.com',    'www.moveconcerts.com',  '@moveconcertscol',  TRUE),
('Ocesa Colombia',                                'empresa_privada',  'info@ocesa.com.co',        'www.ocesa.com.co',      '@ocesacolombia',    TRUE),
('La Tiquetera',                                  'empresa_privada',  'info@latiquetera.com',     'www.latiquetera.com',   '@latiquetera',      TRUE),
('Bandsintown / Productora Local',                'empresa_privada',  'info@bandsintown.com',     'www.bandsintown.com',   '@bandsintown',      TRUE),
('Ticketmaster Colombia',                         'empresa_privada',  'soporte@ticketmaster.co',  'www.ticketmaster.co',   '@ticketmastercol',  TRUE),
('Festival La Solar',                             'empresa_privada',  'info@lasolar.co',          'www.lasolar.co',        '@lasolar_fest',     TRUE),
('Comfama',                                       'entidad_publica',  'eventos@comfama.com',      'www.comfama.com',       '@comfama',          TRUE),
('Teatro Pablo Tobón Uribe',                      'fundacion',        'info@teatropablotobon.com','www.teatropablotobon.com','@tptu_medellin',   TRUE),
('Parque Explora',                                'fundacion',        'info@parqueexplora.org',   'www.parqueexplora.org', '@parqueexplora',    TRUE);
-- Total: 10 registros ✓


-- ============================================================
--  TABLA 3: CATEGORIAS_EVENTO  (10 registros ✓)
-- ============================================================
CREATE TABLE categorias_evento (
    id_categoria          INT AUTO_INCREMENT PRIMARY KEY,
    nombre                VARCHAR(100) NOT NULL,
    descripcion           TEXT,
    publico_objetivo      VARCHAR(100),
    duracion_promedio_min INT,
    requiere_reserva      BOOLEAN DEFAULT FALSE,
    nivel_ruido           ENUM('bajo','medio','alto') DEFAULT 'medio',
    es_al_aire_libre      BOOLEAN DEFAULT FALSE,
    emoji                 VARCHAR(10)
);

INSERT INTO categorias_evento (nombre, descripcion, publico_objetivo, duracion_promedio_min, requiere_reserva, nivel_ruido, es_al_aire_libre, emoji) VALUES
('Concierto',    'Presentación musical en vivo con uno o varios artistas',        'todos',   120, FALSE, 'alto',  FALSE, '🎵'),
('Festival',     'Evento de varios días con múltiples artistas y actividades',    'adultos', 480, FALSE, 'alto',  TRUE,  '🎪'),
('Teatro',       'Obras dramáticas, comedias o performances escénicos',           'adultos',  90, TRUE,  'bajo',  FALSE, '🎭'),
('Comedia',      'Shows de stand-up y humor en vivo',                             'adultos',  90, FALSE, 'medio', FALSE, '😂'),
('Danza',        'Espectáculos de ballet, danza contemporánea o folclor',         'todos',    80, TRUE,  'bajo',  FALSE, '💃'),
('Cultural',     'Ferias, exposiciones, charlas y eventos educativos',            'todos',   180, FALSE, 'bajo',  FALSE, '📚'),
('Arte',         'Exposiciones de artes plásticas, fotografía o instalaciones',  'todos',    60, FALSE, 'bajo',  FALSE, '🎨'),
('Ópera',        'Representaciones de ópera clásica y contemporánea',            'adultos', 100, TRUE,  'bajo',  FALSE, '🎼'),
('Gastronomía',  'Ferias y festivales gastronómicos al aire libre',               'todos',   240, FALSE, 'medio', TRUE,  '🍽️'),
('Cine',         'Proyecciones cinematográficas en diferentes formatos',          'todos',   120, FALSE, 'bajo',  TRUE,  '🎬');
-- Total: 10 registros ✓


-- ============================================================
--  TABLA 4: ARTISTAS  (15 registros)
-- ============================================================
CREATE TABLE artistas (
    id_artista       INT AUTO_INCREMENT PRIMARY KEY,
    nombre_artistico VARCHAR(150) NOT NULL,
    nombre_real      VARCHAR(150),
    tipo_artista     ENUM('musico','banda','compania_teatro','bailarin',
                          'comediante','conferencista','dj','otro') NOT NULL,
    genero_o_estilo  VARCHAR(100),
    pais_origen      VARCHAR(100),
    ciudad_base      VARCHAR(100),
    instagram        VARCHAR(100),
    rating_promedio  DECIMAL(3,2) DEFAULT 0.00
);

INSERT INTO artistas (nombre_artistico, tipo_artista, genero_o_estilo, pais_origen, ciudad_base, instagram, rating_promedio) VALUES
('No Te Va Gustar',   'banda',   'Rock Alternativo',               'Uruguay',    'Montevideo',   '@notevastar',       4.9),
('Depresión Sonora',  'banda',   'Indie Pop / Dream Rock',          'México',    'Ciudad México','@depresionsonora',  4.7),
('Alejo García',      'musico',  'Indie / Folk / Pop',              'Colombia',  'Bogotá',       '@alejogarciamusic', 4.5),
('Grupo Frontera',    'banda',   'Norteño-Pop / Regional Mexicano', 'México',    'McAllen TX',   '@grupofrontera',    4.8),
('DJ Snake',          'dj',      'Electrónica / Dance',             'Francia',   'París',        '@djsnake',          4.9),
('Porter Robinson',   'dj',      'Electrónica / Indie Electronic',  'EE.UU.',    'San Francisco','@porterrobinson',   4.8),
('Yandel',            'musico',  'Reggaetón / Urbano',              'Puerto Rico','Miami',        '@yandel',           4.7),
('Danny Ocean',       'musico',  'Pop Latino / R&B',                'Venezuela', 'Miami',        '@dannyocean',       4.6),
('Rels B',            'musico',  'Trap / Pop Alternativo',          'España',    'Barcelona',    '@relsb',            4.6),
('Morat',             'banda',   'Pop / Indie Pop',                 'Colombia',  'Bogotá',       '@morat',            4.8),
('Carlos Vives',      'musico',  'Vallenato Pop / Cumbia',          'Colombia',  'Bogotá',       '@carlosvives',      4.9),
('Fito Páez',         'musico',  'Rock en Español',                 'Argentina', 'Buenos Aires', '@fitopaezmundo',    4.9),
('Feid',              'musico',  'Urbano / Reggaetón',              'Colombia',  'Medellín',     '@feid',             4.9),
('Arctic Monkeys',    'banda',   'Indie Rock / Post-Punk',          'Reino Unido','Sheffield',   '@arcticmonkeys',    5.0),
('Metallica',         'banda',   'Heavy Metal / Thrash Metal',      'EE.UU.',    'San Francisco','@metallica',        5.0);
-- Total: 15 registros ✓


-- ============================================================
--  TABLA 5: EVENTOS  (15 registros – tabla principal)
-- ============================================================
CREATE TABLE eventos (
    id_evento       INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(200)  NOT NULL,
    descripcion     TEXT,
    id_categoria    INT           NOT NULL,
    id_lugar        INT           NOT NULL,
    id_organizador  INT           NOT NULL,
    precio_minimo   DECIMAL(10,2) DEFAULT 0.00,
    precio_maximo   DECIMAL(10,2) DEFAULT 0.00,
    es_gratuito     BOOLEAN       DEFAULT FALSE,
    aforo_total     INT,
    aforo_ocupado   INT           DEFAULT 0,
    fecha_inicio    DATE          NOT NULL,
    fecha_fin       DATE,
    hora_inicio     TIME          NOT NULL,
    hora_fin        TIME,
    edad_minima     INT           DEFAULT 0,
    enlace_compra   VARCHAR(255),
    estado          ENUM('activo','futuro','finalizado','cancelado') DEFAULT 'futuro',
    frecuencia      ENUM('unico','semanal','mensual','anual','otro') DEFAULT 'unico',
    destacado       BOOLEAN       DEFAULT FALSE,
    fuente          VARCHAR(100),
    fecha_creacion  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_evento_cat  FOREIGN KEY (id_categoria)   REFERENCES categorias_evento(id_categoria),
    CONSTRAINT fk_evento_lug  FOREIGN KEY (id_lugar)       REFERENCES lugares(id_lugar),
    CONSTRAINT fk_evento_org  FOREIGN KEY (id_organizador) REFERENCES organizadores(id_organizador),
    CONSTRAINT chk_aforo      CHECK (aforo_ocupado <= aforo_total OR aforo_total IS NULL),
    CONSTRAINT chk_precio     CHECK (precio_maximo >= precio_minimo)
);

-- ABRIL 2026
INSERT INTO eventos (nombre, descripcion, id_categoria, id_lugar, id_organizador, precio_minimo, precio_maximo, es_gratuito, aforo_total, aforo_ocupado, fecha_inicio, hora_inicio, edad_minima, enlace_compra, estado, destacado, fuente) VALUES
('Stand-Up: Entre Chiste y Chisme', 'Show de comedia donde la Semana Santa se toma con todo el humor del mundo.',                    4,  9, 4,  45000,  75000, FALSE, 400,   380,  '2026-04-03', '21:00:00', 18, 'https://latiquetera.com',    'activo', FALSE, 'La Tiquetera'),
('No Te Va Gustar',                 'La icónica banda uruguaya con su gira 2026. Una noche épica de rock alternativo.',               1,  4, 2, 120000, 250000, FALSE, 3000,  2700, '2026-04-10', '20:00:00',  0, 'https://www.songkick.com',   'activo', TRUE,  'Songkick'),
('Depresión Sonora – Vac. Para Siempre', 'Banda mexicana de indie pop en La Pascasia. Experiencia íntima en El Poblado.',           1,  5, 3,  80000, 160000, FALSE, 1200,  950,  '2026-04-17', '20:00:00', 18, 'https://www.ticketmaster.co','activo', FALSE, 'Ticketmaster'),
('APOCALIPSIS 2026',                'Festival de electrónica de dos noches con los mejores DJs del circuito nacional.',               2,  8, 5,  90000, 180000, FALSE, 3000,  1800, '2026-04-18', '16:00:00', 18, 'https://bandsintown.com',    'activo', FALSE, 'Bandsintown'),
('Grupo Frontera',                  'La agrupación de norteño-pop más popular del planeta llega a Medellín.',                         1,  7, 2, 150000, 350000, FALSE, 8000,  6500, '2026-04-19', '19:00:00',  0, 'https://www.songkick.com',   'activo', TRUE,  'Songkick'),
('Mes de la Danza – Alcaldía',      'Siete días gratuitos de danza en escenarios de toda la ciudad. Ballet, contemporánea, folclor.', 5, 11, 1,      0,      0, TRUE,  NULL,  NULL, '2026-04-23', '10:00:00',  0, 'https://medellin.gov.co',    'futuro', FALSE, 'Alcaldía');

-- MAYO 2026
INSERT INTO eventos (nombre, descripcion, id_categoria, id_lugar, id_organizador, precio_minimo, precio_maximo, es_gratuito, aforo_total, aforo_ocupado, fecha_inicio, hora_inicio, edad_minima, enlace_compra, estado, destacado, fuente) VALUES
('LA SOLAR 2026',                   'DJ Snake, Porter Robinson, Yandel, Danny Ocean, SOFI TUKKER y más artistas internacionales.',    2,  1, 7, 200000, 800000, FALSE, 40000, 36000, '2026-05-02', '14:00:00', 18, 'https://bandsintown.com',    'futuro', TRUE,  'Bandsintown'),
('Rels B',                          'El artista urbano catalán llega a La Macarena con su gira 2026.',                                1,  2, 6, 130000, 300000, FALSE, 10000,  8000, '2026-05-16', '20:00:00', 14, 'https://novushoteles.com',   'futuro', TRUE,  'Novus/Songkick'),
('Feria Popular Días del Libro',    'Feria literaria gratuita. Charlas, talleres y libros a precios especiales. 20ª edición.',         6, 10, 1,      0,      0, TRUE,  NULL,  NULL, '2026-05-22', '09:00:00',  0, 'https://medellin.gov.co',    'futuro', FALSE, 'Alcaldía'),
('Morat',                           'La banda bogotana de pop cierra mayo con su gira mundial en el Atanasio.',                        1,  1, 3, 140000, 400000, FALSE, 45000, 30000, '2026-05-30', '20:00:00',  0, 'https://novushoteles.com',   'futuro', FALSE, 'Novus/Ticketmaster');

-- JUNIO – SEPTIEMBRE 2026
INSERT INTO eventos (nombre, descripcion, id_categoria, id_lugar, id_organizador, precio_minimo, precio_maximo, es_gratuito, aforo_total, aforo_ocupado, fecha_inicio, hora_inicio, edad_minima, enlace_compra, estado, destacado, fuente) VALUES
('Carlos Vives – Tour al Sol',      'El maestro del vallenato pop regresa a Medellín con toda su orquesta y banda.',                  1,  1, 2, 120000, 500000, FALSE, 45000, 40000, '2026-06-06', '19:30:00',  0, 'https://novushoteles.com',   'futuro', TRUE,  'Move Concerts'),
('Fito Páez',                       'El rockero argentino ganador del Grammy Latino en el Teatro Metropolitano.',                      1,  3, 3, 150000, 350000, FALSE,  1800,  1200, '2026-06-12', '20:00:00',  0, 'https://novushoteles.com',   'futuro', FALSE, 'Ocesa'),
('Feid – El Ferxxo en Casa',        'El artista urbano paisa más exitoso del mundo regresa al estadio que lo vio crecer.',             1,  1, 2, 180000, 600000, FALSE, 45000, 43500, '2026-06-20', '21:00:00', 14, 'https://novushoteles.com',   'futuro', TRUE,  'Move Concerts'),
('Feria de las Flores 2026',        'La celebración más emblemática de Medellín. Silleteros, música, gastronomía y espectáculos.',    2, 11, 1,      0,      0, TRUE,  NULL,  NULL, '2026-08-01', '09:00:00',  0, 'https://medellin.gov.co',    'futuro', TRUE,  'Alcaldía'),
('Arctic Monkeys',                  'La legendaria banda de Sheffield en Medellín por primera vez. Noche histórica de indie rock.',    1,  1, 2, 280000, 700000, FALSE, 35000, 33000, '2026-08-08', '20:00:00',  0, 'https://novushoteles.com',   'futuro', TRUE,  'Move Concerts'),
('Metallica – M72 World Tour',      'La banda de metal más grande de la historia. Producción colosal, pirotecnia y 30+ canciones.',   1,  1, 2, 250000, 900000, FALSE, 45000, 44000, '2026-09-05', '20:00:00',  0, 'https://novushoteles.com',   'futuro', TRUE,  'Move Concerts');
-- Total: 15 registros ✓ (todos los eventos tienen ≥10)


-- ============================================================
--  TABLA 6: EVENTO_ARTISTA  (15 registros)
-- ============================================================
CREATE TABLE evento_artista (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    id_evento         INT NOT NULL,
    id_artista        INT NOT NULL,
    rol               VARCHAR(80) DEFAULT 'artista_principal',
    orden_aparicion   INT DEFAULT 1,
    hora_presentacion TIME,

    CONSTRAINT fk_ea_evento  FOREIGN KEY (id_evento)  REFERENCES eventos(id_evento) ON DELETE CASCADE,
    CONSTRAINT fk_ea_artista FOREIGN KEY (id_artista) REFERENCES artistas(id_artista),
    UNIQUE KEY uq_ev_art (id_evento, id_artista)
);

INSERT INTO evento_artista (id_evento, id_artista, rol, orden_aparicion, hora_presentacion) VALUES
(2,  1,  'artista_principal', 1, '21:00:00'), -- No Te Va Gustar
(3,  2,  'artista_principal', 1, '21:00:00'), -- Depresión Sonora
(5,  4,  'artista_principal', 1, '20:30:00'), -- Grupo Frontera
(7,  5,  'artista_principal', 1, '23:00:00'), -- LA SOLAR: DJ Snake
(7,  6,  'artista_principal', 2, '21:00:00'), -- LA SOLAR: Porter Robinson
(7,  7,  'artista_principal', 3, '22:00:00'), -- LA SOLAR: Yandel
(7,  8,  'telonero',          4, '19:00:00'), -- LA SOLAR: Danny Ocean
(8,  9,  'artista_principal', 1, '21:00:00'), -- Rels B
(9,  10, 'artista_principal', 1, '21:00:00'), -- Morat
(10, 11, 'artista_principal', 1, '20:30:00'), -- Carlos Vives
(11, 12, 'artista_principal', 1, '21:00:00'), -- Fito Páez
(12, 13, 'artista_principal', 1, '22:00:00'), -- Feid
(14, 14, 'artista_principal', 1, '21:00:00'), -- Arctic Monkeys
(15, 15, 'artista_principal', 1, '20:30:00'), -- Metallica
(15, 14, 'telonero',          2, '18:30:00'); -- Arctic como telonero de Metallica (hipotético)
-- Total: 15 registros ✓


-- ============================================================
--  TABLA 7: RESEÑAS  (10 registros ✓)
-- ============================================================
CREATE TABLE resenas (
    id_resena         INT AUTO_INCREMENT PRIMARY KEY,
    id_evento         INT      NOT NULL,
    nombre_usuario    VARCHAR(100) NOT NULL,
    calificacion      TINYINT  NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    titulo            VARCHAR(200),
    comentario        TEXT,
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verificado        BOOLEAN   DEFAULT FALSE,

    CONSTRAINT fk_res_evento FOREIGN KEY (id_evento) REFERENCES eventos(id_evento) ON DELETE CASCADE
);

INSERT INTO resenas (id_evento, nombre_usuario, calificacion, titulo, comentario, verificado) VALUES
(1,  'Valentina Ríos',      5, '¡Me partí de la risa!',          'El show fue increíble, Medellín es un público muy especial.',        TRUE),
(1,  'Camilo Hernández',    4, 'Muy bueno pero el sonido falló',  'El comediante estuvo genial pero los micrófonos tuvieron problemas.', FALSE),
(2,  'Sara Montoya',        5, 'Noche épica en Medellín',         'No Te Va Gustar superó todas mis expectativas. Cada canción fue un himno.', TRUE),
(2,  'Juan Pablo Vélez',    5, 'Los mejores en vivo',             'Una producción impecable. El estadio vibró de principio a fin.',     TRUE),
(5,  'Daniela Cano',        4, 'Grupo Frontera lo rompe todo',    'Mucho mejor de lo esperado. Las canciones en vivo suenan aún mejor.', TRUE),
(3,  'Isabela Zuluaga',     5, 'Depresión Sonora: experiencia',   'El ambiente de La Pascasia con Depresión Sonora fue magia pura.',    TRUE),
(7,  'Carlos Mejía',        5, 'La Solar fue increíble',          'DJ Snake fue lo mejor del año. La producción superó todo.',          TRUE),
(8,  'Valentina Ossa',      5, 'Rels B, qué energía',             'El show de Rels B fue brutal. La Macarena se quedó chica.',          TRUE),
(10, 'Santiago López',      5, 'Carlos Vives no defrauda',        'Un espectáculo de clase mundial. El vallenato nunca sonó tan bien.', TRUE),
(12, 'Luisa Fernanda G.',   4, 'Feid en casa es diferente',       'Verlo en el Atanasio fue emocionante. El aforo enorme pero maravilloso.', TRUE);
-- Total: 10 registros ✓


-- ============================================================
--  ÍNDICES DE RENDIMIENTO
-- ============================================================
CREATE INDEX idx_eventos_estado    ON eventos(estado);
CREATE INDEX idx_eventos_fecha     ON eventos(fecha_inicio);
CREATE INDEX idx_eventos_categoria ON eventos(id_categoria);
CREATE INDEX idx_eventos_gratuito  ON eventos(es_gratuito);
CREATE INDEX idx_resenas_evento    ON resenas(id_evento);
CREATE INDEX idx_ea_evento         ON evento_artista(id_evento);


-- ============================================================
--  VISTAS GUARDADAS (CREATE VIEW) ← REQUISITO CUMPLIDO ✓
-- ============================================================

-- VIEW 1: Vista principal de la app – eventos completos con lugar, categoría y organización
CREATE OR REPLACE VIEW v_eventos_completos AS
SELECT
    e.id_evento,
    e.nombre                                        AS evento,
    c.nombre                                        AS categoria,
    c.emoji,
    l.nombre                                        AS lugar,
    l.barrio,
    o.nombre                                        AS organizador,
    IF(e.es_gratuito, 'GRATIS',
       CONCAT('$', FORMAT(e.precio_minimo,0), ' – $', FORMAT(e.precio_maximo,0))) AS precio,
    e.es_gratuito,
    e.aforo_total,
    e.aforo_ocupado,
    (e.aforo_total - e.aforo_ocupado)               AS puestos_libres,
    ROUND(e.aforo_ocupado / e.aforo_total * 100, 1) AS pct_ocupacion,
    e.fecha_inicio,
    DATE_FORMAT(e.fecha_inicio, '%d de %M de %Y')  AS fecha_formateada,
    e.hora_inicio,
    e.edad_minima,
    e.enlace_compra,
    e.estado,
    e.destacado
FROM eventos e
JOIN categorias_evento c ON e.id_categoria = c.id_categoria
JOIN lugares l           ON e.id_lugar     = l.id_lugar
JOIN organizadores o     ON e.id_organizador = o.id_organizador
WHERE e.estado IN ('activo', 'futuro');

-- ► Uso: SELECT * FROM v_eventos_completos ORDER BY fecha_inicio;


-- VIEW 2: Calificación y estadísticas de reseñas por evento
CREATE OR REPLACE VIEW v_eventos_rating AS
SELECT
    e.id_evento,
    e.nombre                                        AS evento,
    e.estado,
    COUNT(r.id_resena)                              AS total_resenas,
    ROUND(AVG(r.calificacion), 2)                   AS rating_promedio,
    SUM(CASE WHEN r.calificacion = 5 THEN 1 ELSE 0 END) AS resenas_5_estrellas,
    MIN(r.calificacion)                             AS peor_calificacion,
    MAX(r.calificacion)                             AS mejor_calificacion
FROM eventos e
LEFT JOIN resenas r ON e.id_evento = r.id_evento
GROUP BY e.id_evento, e.nombre, e.estado;

-- ► Uso: SELECT * FROM v_eventos_rating WHERE total_resenas > 0 ORDER BY rating_promedio DESC;


-- VIEW 3: Artistas más activos en la plataforma
CREATE OR REPLACE VIEW v_artistas_populares AS
SELECT
    a.id_artista,
    a.nombre_artistico,
    a.tipo_artista,
    a.genero_o_estilo,
    a.pais_origen,
    COUNT(ea.id_evento)                             AS total_eventos,
    a.rating_promedio
FROM artistas a
LEFT JOIN evento_artista ea ON a.id_artista = ea.id_artista
GROUP BY a.id_artista, a.nombre_artistico, a.tipo_artista, a.genero_o_estilo, a.pais_origen, a.rating_promedio
ORDER BY total_eventos DESC;

-- ► Uso: SELECT * FROM v_artistas_populares LIMIT 10;


-- ============================================================
--  OPERACIONES SQL COMPLETAS
-- ============================================================

-- ── SELECT básico con WHERE ─────────────────────────────────
SELECT nombre, fecha_inicio, hora_inicio, es_gratuito, estado
FROM eventos
WHERE estado IN ('activo','futuro')
ORDER BY fecha_inicio ASC;

-- ── SELECT con WHERE y filtro de precio ────────────────────
SELECT nombre, precio_minimo, precio_maximo, fecha_inicio
FROM eventos
WHERE precio_minimo <= 100000
  AND es_gratuito = FALSE
  AND estado != 'cancelado'
ORDER BY precio_minimo ASC;

-- ── INNER JOIN: eventos con lugar y categoría ──────────────
SELECT e.nombre AS evento, c.nombre AS categoria, c.emoji,
       l.nombre AS lugar, l.barrio,
       e.fecha_inicio, e.hora_inicio,
       IF(e.es_gratuito,'GRATIS', CONCAT('$',FORMAT(e.precio_minimo,0))) AS precio
FROM eventos e
INNER JOIN categorias_evento c ON e.id_categoria = c.id_categoria
INNER JOIN lugares l           ON e.id_lugar     = l.id_lugar
WHERE e.estado IN ('activo','futuro')
ORDER BY e.fecha_inicio;

-- ── LEFT JOIN: eventos con reseñas (incluyendo sin reseñas)─
SELECT e.nombre, COUNT(r.id_resena) AS total_resenas,
       ROUND(AVG(r.calificacion), 1) AS rating
FROM eventos e
LEFT JOIN resenas r ON e.id_evento = r.id_evento
GROUP BY e.id_evento, e.nombre
ORDER BY rating DESC;

-- ── GROUP BY + funciones COUNT, AVG, SUM ───────────────────
SELECT c.nombre AS categoria,
       COUNT(e.id_evento)          AS total_eventos,
       ROUND(AVG(e.precio_minimo)) AS precio_promedio,
       SUM(CASE WHEN e.es_gratuito THEN 1 ELSE 0 END) AS gratuitos
FROM categorias_evento c
LEFT JOIN eventos e ON c.id_categoria = e.id_categoria
GROUP BY c.id_categoria, c.nombre
ORDER BY total_eventos DESC;

-- ── ORDER BY combinado ─────────────────────────────────────
SELECT nombre, precio_minimo, precio_maximo, fecha_inicio
FROM eventos
WHERE estado = 'futuro'
ORDER BY precio_maximo DESC, fecha_inicio ASC;

-- ── SUBCONSULTA: eventos con precio > promedio ─────────────
SELECT nombre, precio_minimo
FROM eventos
WHERE precio_minimo > (
    SELECT AVG(precio_minimo)
    FROM eventos
    WHERE es_gratuito = FALSE
)
ORDER BY precio_minimo DESC;

-- ── SUBCONSULTA: categorías con al menos un evento activo ──
SELECT nombre AS categoria
FROM categorias_evento
WHERE id_categoria IN (
    SELECT DISTINCT id_categoria
    FROM eventos
    WHERE estado = 'activo'
      AND MONTH(fecha_inicio) = MONTH(CURDATE())
);

-- ── UPDATE: actualizar aforo cuando se vende una boleta ────
UPDATE eventos
SET aforo_ocupado = aforo_ocupado + 1
WHERE id_evento = 2
  AND aforo_ocupado < aforo_total;

-- ── UPDATE: marcar eventos pasados como finalizados ────────
UPDATE eventos
SET estado = 'finalizado'
WHERE fecha_inicio < CURDATE()
  AND estado = 'activo';

-- ── DELETE: borrar reseñas de eventos cancelados ──────────
DELETE FROM resenas
WHERE id_evento IN (
    SELECT id_evento FROM eventos WHERE estado = 'cancelado'
);

-- ── USAR LAS VISTAS ────────────────────────────────────────
-- Vista 1: todos los eventos activos/futuros completos
SELECT * FROM v_eventos_completos ORDER BY fecha_inicio;

-- Vista 2: eventos con mejor rating
SELECT * FROM v_eventos_rating WHERE total_resenas > 0 ORDER BY rating_promedio DESC;

-- Vista 3: artistas que más aparecen
SELECT * FROM v_artistas_populares WHERE total_eventos > 0;

-- ============================================================
--  RESUMEN DE CUMPLIMIENTO
-- ============================================================
-- ✅ 7 tablas relacionadas (dentro del rango 5–8)
-- ✅ PRIMARY KEY en cada tabla (AUTO_INCREMENT)
-- ✅ FOREIGN KEY: fk_evento_cat, fk_evento_lug, fk_evento_org,
--    fk_ea_evento, fk_ea_artista, fk_res_evento (6 FKs ≥ 3)
-- ✅ Normalización 3NF
-- ✅ CREATE TABLE con restricciones (NOT NULL, ENUM, CHECK, DEFAULT)
-- ✅ INSERT INTO ≥ 10 registros en TODAS las tablas
-- ✅ SELECT con WHERE, ORDER BY, GROUP BY
-- ✅ UPDATE y DELETE funcionales
-- ✅ Al menos 2 JOINs (INNER y LEFT)
-- ✅ 3 CREATE VIEW guardadas
-- ✅ 2 Subconsultas con IN y AVG
-- ✅ Funciones COUNT, AVG, SUM, MIN, MAX
-- ============================================================
