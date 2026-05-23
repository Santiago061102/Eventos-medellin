-- ============================================================
--  ENTREGABLE B — Consultas SQL de negocio
--  Proyecto: ¿Qué Hay en Medellín? 🌸
--  Base de datos: medellin_eventos (Supabase / PostgreSQL)
--  Curso: Sistemas de Gestión de Bases de Datos · DatAI
-- ============================================================


-- ============================================================
--  CONSULTA 1: Eventos activos y futuros con lugar y categoría
--  Técnica: INNER JOIN (3 tablas) + WHERE + ORDER BY
--  Pregunta de negocio: ¿Qué eventos están disponibles,
--  dónde son y cuánto cuestan?
-- ============================================================

SELECT
    e.nombre                                              AS evento,
    c.emoji || ' ' || c.nombre                           AS categoria,
    l.nombre                                             AS lugar,
    l.barrio,
    e.fecha_inicio,
    e.hora_inicio,
    CASE
        WHEN e.es_gratuito THEN 'GRATIS'
        ELSE '$' || TO_CHAR(e.precio_minimo, 'FM999,999,999')
             || ' – $' || TO_CHAR(e.precio_maximo, 'FM999,999,999')
    END                                                  AS precio,
    e.estado
FROM eventos e
INNER JOIN categorias_evento c ON e.id_categoria = c.id_categoria
INNER JOIN lugares l           ON e.id_lugar     = l.id_lugar
WHERE e.estado IN ('activo', 'futuro')
ORDER BY e.fecha_inicio ASC;


-- ============================================================
--  CONSULTA 2: Ranking de categorías por número de eventos
--  y precio promedio
--  Técnica: LEFT JOIN + GROUP BY + COUNT + AVG + SUM
--  Pregunta de negocio: ¿Qué tipo de eventos predomina en
--  Medellín y cuál es su costo promedio?
-- ============================================================

SELECT
    c.emoji || ' ' || c.nombre                          AS categoria,
    COUNT(e.id_evento)                                  AS total_eventos,
    SUM(CASE WHEN e.es_gratuito THEN 1 ELSE 0 END)      AS eventos_gratuitos,
    SUM(CASE WHEN NOT e.es_gratuito THEN 1 ELSE 0 END)  AS eventos_de_pago,
    ROUND(AVG(e.precio_minimo)::NUMERIC, 0)             AS precio_promedio_cop,
    MAX(e.precio_maximo)                                AS precio_maximo_cop
FROM categorias_evento c
LEFT JOIN eventos e ON c.id_categoria = e.id_categoria
GROUP BY c.id_categoria, c.emoji, c.nombre
ORDER BY total_eventos DESC;


-- ============================================================
--  CONSULTA 3: Top 10 eventos por ocupación de aforo
--  Técnica: WHERE + ORDER BY + ROUND + subconsulta implícita
--  Pregunta de negocio: ¿Qué eventos tienen mayor demanda
--  según su porcentaje de ocupación?
-- ============================================================

SELECT
    e.nombre                                                     AS evento,
    l.nombre                                                     AS lugar,
    e.aforo_total,
    e.aforo_ocupado,
    ROUND(
        CAST(e.aforo_ocupado AS NUMERIC) / NULLIF(e.aforo_total, 0) * 100,
    1)                                                           AS pct_ocupacion,
    e.fecha_inicio,
    e.estado
FROM eventos e
INNER JOIN lugares l ON e.id_lugar = l.id_lugar
WHERE e.aforo_total IS NOT NULL
  AND e.aforo_ocupado IS NOT NULL
ORDER BY pct_ocupacion DESC
LIMIT 10;


-- ============================================================
--  CONSULTA 4: Eventos con precio por encima del promedio
--  Técnica: Subconsulta escalar + WHERE
--  Pregunta de negocio: ¿Cuáles son los eventos más costosos
--  respecto al precio promedio del mercado?
-- ============================================================

SELECT
    e.nombre                                                     AS evento,
    c.nombre                                                     AS categoria,
    e.precio_minimo,
    ROUND(
        e.precio_minimo - (
            SELECT AVG(precio_minimo)
            FROM eventos
            WHERE es_gratuito = FALSE
              AND precio_minimo > 0
        )
    , 0)                                                         AS diferencia_vs_promedio,
    e.fecha_inicio
FROM eventos e
INNER JOIN categorias_evento c ON e.id_categoria = c.id_categoria
WHERE e.precio_minimo > (
    SELECT AVG(precio_minimo)
    FROM eventos
    WHERE es_gratuito = FALSE
      AND precio_minimo > 0
)
ORDER BY e.precio_minimo DESC;


-- ============================================================
--  CONSULTA 5: Calificación promedio y reseñas por evento
--  Técnica: LEFT JOIN + GROUP BY + AVG + COUNT + MIN + MAX
--  Pregunta de negocio: ¿Qué eventos tienen mejor recepción
--  del público según sus reseñas?
-- ============================================================

SELECT
    e.nombre                                             AS evento,
    e.estado,
    COUNT(r.id_resena)                                  AS total_resenas,
    ROUND(AVG(r.calificacion)::NUMERIC, 2)              AS rating_promedio,
    SUM(CASE WHEN r.calificacion = 5 THEN 1 ELSE 0 END) AS resenas_5_estrellas,
    MIN(r.calificacion)                                 AS peor_calificacion,
    MAX(r.calificacion)                                 AS mejor_calificacion
FROM eventos e
LEFT JOIN resenas r ON e.id_evento = r.id_evento
GROUP BY e.id_evento, e.nombre, e.estado
HAVING COUNT(r.id_resena) > 0
ORDER BY rating_promedio DESC, total_resenas DESC;


-- ============================================================
--  CONSULTA 6: Artistas con más eventos y su rating
--  Técnica: JOIN N:M (evento_artista) + GROUP BY + COUNT
--  Pregunta de negocio: ¿Qué artistas son más activos
--  en la plataforma y cómo se valoran?
-- ============================================================

SELECT
    a.nombre_artistico,
    a.tipo_artista,
    a.genero_o_estilo,
    a.pais_origen,
    COUNT(ea.id_evento)                                 AS total_eventos,
    a.rating_promedio
FROM artistas a
LEFT JOIN evento_artista ea ON a.id_artista = ea.id_artista
GROUP BY
    a.id_artista, a.nombre_artistico, a.tipo_artista,
    a.genero_o_estilo, a.pais_origen, a.rating_promedio
ORDER BY total_eventos DESC, a.rating_promedio DESC;


-- ============================================================
--  CONSULTA 7 (CTE): Lugares con más eventos y su ocupación
--  Técnica: CTE (WITH) + JOIN + GROUP BY + AVG
--  Pregunta de negocio: ¿Qué recintos concentran más
--  actividad cultural y qué tan llenos suelen estar?
-- ============================================================

WITH resumen_lugares AS (
    SELECT
        l.id_lugar,
        l.nombre                                        AS lugar,
        l.tipo_lugar,
        l.barrio,
        l.capacidad_total,
        COUNT(e.id_evento)                             AS total_eventos,
        SUM(CASE WHEN e.es_gratuito THEN 1 ELSE 0 END) AS eventos_gratuitos,
        ROUND(
            AVG(
                CASE WHEN e.aforo_total > 0
                THEN CAST(e.aforo_ocupado AS NUMERIC) / e.aforo_total * 100
                END
            )::NUMERIC, 1
        )                                              AS ocupacion_promedio_pct
    FROM lugares l
    LEFT JOIN eventos e ON l.id_lugar = e.id_lugar
    GROUP BY l.id_lugar, l.nombre, l.tipo_lugar, l.barrio, l.capacidad_total
)
SELECT *
FROM resumen_lugares
WHERE total_eventos > 0
ORDER BY total_eventos DESC, ocupacion_promedio_pct DESC NULLS LAST;


-- ============================================================
--  CONSULTA 8 (WINDOW FUNCTION): Ranking de eventos por
--  precio dentro de cada categoría
--  Técnica: RANK() OVER (PARTITION BY ... ORDER BY ...)
--  Pregunta de negocio: ¿Cuál es el evento más costoso
--  dentro de cada categoría?
-- ============================================================

SELECT
    c.nombre                                            AS categoria,
    e.nombre                                            AS evento,
    e.precio_minimo,
    e.precio_maximo,
    RANK() OVER (
        PARTITION BY e.id_categoria
        ORDER BY e.precio_minimo DESC
    )                                                   AS ranking_precio_en_categoria,
    ROUND(AVG(e.precio_minimo) OVER (
        PARTITION BY e.id_categoria
    )::NUMERIC, 0)                                      AS promedio_categoria
FROM eventos e
INNER JOIN categorias_evento c ON e.id_categoria = c.id_categoria
WHERE e.es_gratuito = FALSE
  AND e.precio_minimo > 0
ORDER BY c.nombre, ranking_precio_en_categoria;


-- ============================================================
--  CONSULTA 9 (WINDOW FUNCTION): Acumulado mensual de eventos
--  Técnica: COUNT() OVER (ORDER BY mes) — running total
--  Pregunta de negocio: ¿Cómo crece la agenda cultural
--  mes a mes a lo largo del año?
-- ============================================================

WITH eventos_por_mes AS (
    SELECT
        TO_CHAR(fecha_inicio, 'MM')                    AS mes_num,
        TO_CHAR(fecha_inicio, 'TMMonth')               AS mes_nombre,
        COUNT(*)                                       AS eventos_en_mes,
        SUM(CASE WHEN es_gratuito THEN 1 ELSE 0 END)   AS gratuitos_en_mes
    FROM eventos
    WHERE fecha_inicio IS NOT NULL
    GROUP BY TO_CHAR(fecha_inicio, 'MM'), TO_CHAR(fecha_inicio, 'TMMonth')
)
SELECT
    mes_nombre,
    eventos_en_mes,
    gratuitos_en_mes,
    SUM(eventos_en_mes) OVER (
        ORDER BY mes_num
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                  AS acumulado_eventos
FROM eventos_por_mes
ORDER BY mes_num;


-- ============================================================
--  CONSULTA 10 (CTE + WINDOW): Organizadores más activos
--  con su participación relativa en el total
--  Técnica: CTE + COUNT + ROUND + SUM OVER ()
--  Pregunta de negocio: ¿Qué organizadores dominan la
--  agenda y qué porcentaje del total representan?
-- ============================================================

WITH por_organizador AS (
    SELECT
        o.nombre                                        AS organizador,
        o.tipo_organizacion,
        o.verificado,
        COUNT(e.id_evento)                             AS total_eventos,
        SUM(CASE WHEN e.es_gratuito THEN 1 ELSE 0 END) AS eventos_gratuitos
    FROM organizadores o
    LEFT JOIN eventos e ON o.id_organizador = e.id_organizador
    GROUP BY o.id_organizador, o.nombre, o.tipo_organizacion, o.verificado
)
SELECT
    organizador,
    tipo_organizacion,
    verificado,
    total_eventos,
    eventos_gratuitos,
    ROUND(
        CAST(total_eventos AS NUMERIC)
        / NULLIF(SUM(total_eventos) OVER (), 0) * 100
    , 1)                                               AS pct_del_total
FROM por_organizador
WHERE total_eventos > 0
ORDER BY total_eventos DESC;
