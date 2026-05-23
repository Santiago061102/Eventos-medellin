# 🌸 ¿Qué Hay en Medellín?

> Agenda cultural de eventos en vivo para Medellín, Colombia — 2026

**Demo en vivo:** [santiago061102.github.io/Eventos-medellin](https://santiago061102.github.io/Eventos-medellin/)

---

## Descripción

**¿Qué Hay en Medellín?** es una aplicación web que centraliza la agenda cultural de la ciudad: conciertos, festivales, teatro, comedia, danza, arte, gastronomía y mucho más. Los usuarios pueden explorar, filtrar y ordenar los eventos del año según sus intereses, con información en tiempo real conectada a una base de datos en Supabase.

El proyecto también funciona como demostración práctica de un modelo relacional completo, con **6 tablas** y sus respectivas llaves foráneas.

---

## Funcionalidades

- Listado de eventos de Medellín para el 2026 (abril a septiembre)
- Filtrado por categoría: concierto, festival, teatro, comedia, danza, cultural, arte y gastronomía
- Filtro de eventos gratuitos
- Filtrado por mes
- Ordenamiento por fecha, precio (ascendente/descendente) y nombre
- Conexión en tiempo real a Supabase
- Diseño responsive adaptado a móvil y escritorio

---

## Tecnologías

| Capa | Tecnología |
|------|-----------|
| Frontend | HTML, CSS, JavaScript |
| Base de datos | Supabase (PostgreSQL) |
| Hosting | GitHub Pages |

---

## Modelo de base de datos

El proyecto implementa un modelo relacional con 6 tablas:

| Tabla | Descripción |
|-------|-------------|
| `EVENTOS` | Tabla central. Almacena nombre, precio, aforo, fechas y estado de cada evento |
| `ORGANIZADORES` | Persona o entidad que gestiona el evento |
| `CATEGORIAS_EVENTO` | Clasificación del evento (música, teatro, gastronomía, etc.) |
| `LUGARES` | Espacio físico: tipo, barrio y capacidad |
| `ARTISTAS` | Intérpretes que participan en los eventos |
| `RESEÑAS` | Opiniones y calificaciones de asistentes |

### Relaciones

- Un **organizador** puede gestionar muchos eventos (1:N)
- Una **categoría** agrupa muchos eventos del mismo tipo (1:N)
- Un **lugar** puede albergar muchos eventos en distintas fechas (1:N)
- Un **evento** puede tener muchos **artistas** y un artista puede aparecer en muchos eventos (N:M → tabla intermedia `EVENTO_ARTISTA`)
- Un **evento** puede recibir muchas **reseñas** (1:N)

---
