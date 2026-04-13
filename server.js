// server.js — API REST para ¿Qué Hay en Medellín?
// Conecta el frontend con MySQL en Railway/cualquier servidor

const express = require('express');
const mysql   = require('mysql2/promise');
const cors    = require('cors');
require('dotenv').config();

const app  = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public')); // sirve el index.html desde /public

// ── Conexión a MySQL ──────────────────────────────────────────
const pool = mysql.createPool({
  host    : process.env.DB_HOST     || 'localhost',
  port    : process.env.DB_PORT     || 3306,
  user    : process.env.DB_USER     || 'root',
  password: process.env.DB_PASS     || '',
  database: process.env.DB_NAME     || 'medellin_eventos',
  waitForConnections: true,
  connectionLimit   : 10,
});

// ── Helper ────────────────────────────────────────────────────
async function query(sql, params = []) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

// ══════════════════════════════════════════════════════════════
//  EVENTOS
// ══════════════════════════════════════════════════════════════

// GET /api/eventos — todos los eventos con JOIN
app.get('/api/eventos', async (req, res) => {
  try {
    const rows = await query(`
      SELECT e.id_evento AS id, e.nombre, e.descripcion AS desc,
             e.id_categoria AS cat, c.nombre AS cat_nombre, c.emoji,
             e.id_lugar AS lugar, l.nombre AS lugar_nombre, l.barrio,
             e.id_organizador AS org, o.nombre AS org_nombre,
             e.precio_minimo AS pmin, e.precio_maximo AS pmax,
             e.es_gratuito AS gratis, e.aforo_total AS aforo,
             e.aforo_ocupado AS occ, e.fecha_inicio AS fecha,
             e.hora_inicio AS hora, e.edad_minima AS edad,
             e.enlace_compra AS link, e.estado, e.destacado AS hot,
             e.fuente
      FROM   eventos e
      JOIN   categorias_evento c ON e.id_categoria = c.id_categoria
      JOIN   lugares           l ON e.id_lugar     = l.id_lugar
      JOIN   organizadores     o ON e.id_organizador = o.id_organizador
      ORDER  BY e.fecha_inicio ASC
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/eventos/:id
app.get('/api/eventos/:id', async (req, res) => {
  try {
    const rows = await query(
      'SELECT * FROM eventos WHERE id_evento = ?',
      [req.params.id]
    );
    if (!rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/eventos — INSERT
app.post('/api/eventos', async (req, res) => {
  const b = req.body;
  try {
    const result = await query(`
      INSERT INTO eventos
        (nombre, descripcion, id_categoria, id_lugar, id_organizador,
         precio_minimo, precio_maximo, es_gratuito, aforo_total, aforo_ocupado,
         fecha_inicio, hora_inicio, edad_minima, enlace_compra,
         estado, destacado, fuente)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    `, [
      b.nombre, b.desc||null, b.cat, b.lugar, b.org,
      b.pmin||0, b.pmax||0, b.gratis||false, b.aforo||null, b.occ||0,
      b.fecha, b.hora, b.edad||0, b.link||null,
      b.estado||'futuro', b.hot||false, b.fuente||null
    ]);
    res.json({ id: result.insertId, ok: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/eventos/:id — UPDATE
app.put('/api/eventos/:id', async (req, res) => {
  const b = req.body;
  try {
    await query(`
      UPDATE eventos SET
        nombre=?, descripcion=?, id_categoria=?, id_lugar=?, id_organizador=?,
        precio_minimo=?, precio_maximo=?, es_gratuito=?, aforo_total=?,
        aforo_ocupado=?, fecha_inicio=?, hora_inicio=?, edad_minima=?,
        enlace_compra=?, estado=?, destacado=?, fuente=?
      WHERE id_evento=?
    `, [
      b.nombre, b.desc||null, b.cat, b.lugar, b.org,
      b.pmin||0, b.pmax||0, b.gratis||false, b.aforo||null, b.occ||0,
      b.fecha, b.hora, b.edad||0, b.link||null,
      b.estado||'futuro', b.hot||false, b.fuente||null,
      req.params.id
    ]);
    res.json({ ok: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/eventos/:id
app.delete('/api/eventos/:id', async (req, res) => {
  try {
    await query('DELETE FROM eventos WHERE id_evento=?', [req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ══════════════════════════════════════════════════════════════
//  TABLAS DE APOYO (GET-only para los selects del admin)
// ══════════════════════════════════════════════════════════════

app.get('/api/lugares',       async (req, res) => { try { res.json(await query('SELECT * FROM lugares ORDER BY nombre'));                } catch(e){ res.status(500).json({error:e.message}); } });
app.get('/api/organizadores', async (req, res) => { try { res.json(await query('SELECT * FROM organizadores ORDER BY nombre'));         } catch(e){ res.status(500).json({error:e.message}); } });
app.get('/api/categorias',    async (req, res) => { try { res.json(await query('SELECT * FROM categorias_evento ORDER BY nombre'));     } catch(e){ res.status(500).json({error:e.message}); } });
app.get('/api/artistas',      async (req, res) => { try { res.json(await query('SELECT * FROM artistas ORDER BY nombre_artistico'));    } catch(e){ res.status(500).json({error:e.message}); } });
app.get('/api/resenas',       async (req, res) => { try { res.json(await query('SELECT * FROM resenas ORDER BY fecha_publicacion DESC'));} catch(e){ res.status(500).json({error:e.message}); } });

// POST para resenas
app.post('/api/resenas', async (req, res) => {
  const b = req.body;
  try {
    const result = await query(
      'INSERT INTO resenas (id_evento,nombre_usuario,calificacion,titulo,comentario) VALUES (?,?,?,?,?)',
      [b.evento, b.usuario, b.calif, b.titulo||null, b.comentario||null]
    );
    res.json({ id: result.insertId, ok: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE para resenas
app.delete('/api/resenas/:id', async (req, res) => {
  try {
    await query('DELETE FROM resenas WHERE id_resena=?', [req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ══════════════════════════════════════════════════════════════
//  VISTAS SQL (consultas avanzadas)
// ══════════════════════════════════════════════════════════════

app.get('/api/views/eventos-completos', async (req, res) => {
  try { res.json(await query('SELECT * FROM v_eventos_completos')); }
  catch(e) { res.status(500).json({ error: e.message }); }
});

app.get('/api/views/eventos-rating', async (req, res) => {
  try { res.json(await query('SELECT * FROM v_eventos_rating ORDER BY rating_promedio DESC')); }
  catch(e) { res.status(500).json({ error: e.message }); }
});

app.get('/api/views/artistas-populares', async (req, res) => {
  try { res.json(await query('SELECT * FROM v_artistas_populares')); }
  catch(e) { res.status(500).json({ error: e.message }); }
});

// ── Health check ──────────────────────────────────────────────
app.get('/api/health', async (req, res) => {
  try {
    await query('SELECT 1');
    res.json({ status: 'ok', db: 'conectada', timestamp: new Date() });
  } catch (e) {
    res.status(500).json({ status: 'error', db: e.message });
  }
});

// ── Iniciar servidor ──────────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
  console.log(`BD: ${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || 3306}/${process.env.DB_NAME || 'medellin_eventos'}`);
});
