 📊 GA4 Marketing Analytics — SQL Portfolio

Análisis de comportamiento de usuario y conversión sobre datos reales de GA4 usando **BigQuery SQL**.  
Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce` · Período: Nov 2020 – Ene 2021

---

 Herramientas
- **Google BigQuery** — consultas SQL sobre datos anidados (ARRAY de STRUCTs)
- **SQL** — CTEs, window functions, UNNEST, aggregations
- **GitHub** — documentación y versionado del proyecto

---

## 🗂️ Estructura del proyecto

```
ga4-marketing-analytics/
│
├── queries/
│   ├── q1_eventos_frecuentes.sql
│   ├── q2_usuarios_unicos_por_fecha.sql
│   ├── q3_canal_de_trafico.sql
│   ├── q4_paginas_mas_visitadas.sql
│   ├── q5_funnel_conversion.sql
│   ├── q6_eventos_por_sesion.sql
│   ├── q7_revenue_por_fecha.sql
│   ├── q8_productos_vistos_vs_comprados.sql
│   ├── q9_ticket_promedio_usuario.sql
│   └── q10_ranking_usuarios_revenue.sql
│
└── README.md
```

---

## 📌 Preguntas de negocio respondidas

### Bloque 1 — Exploración y tráfico

#### Q1 · ¿Cuáles son los 10 eventos más frecuentes?
```sql
SELECT
  event_name,
  COUNT(*) AS numero_eventos
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
ORDER BY numero_eventos DESC
LIMIT 10
```
**Insight:** `page_view` fue el evento más frecuente (1,350,428 ocurrencias), seguido de `user_engagement` (1,058,721) y `scroll` (493,072). Se observa una caída brusca entre `view_item` (386,068) y `add_to_cart` (58,543), señalando una fuga temprana en el funnel de conversión.

---

#### Q2 · ¿Cuántos usuarios únicos hubo por día?
```sql
SELECT
  event_date,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_date
ORDER BY event_date ASC
```
**Insight:** Permite identificar tendencias de tráfico diario y detectar picos asociados a campañas o fechas estacionales como Black Friday o Navidad.

---

#### Q3 · ¿Por qué canal llegaron más usuarios y sesiones?
```sql
SELECT
  traffic_source.medium AS canal,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos,
  COUNT(DISTINCT param.value.int_value) AS sesiones
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS param
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND param.key = 'ga_session_id'
GROUP BY canal
ORDER BY sesiones DESC
```
**Insight:** El canal `organic` lidera con 112,358 usuarios únicos y 121,488 sesiones. El canal `cpc` (paid) es el más bajo con 15,528 usuarios, lo que sugiere alta dependencia del tráfico orgánico y una oportunidad de crecimiento en medios pagados.

---

### Bloque 2 — Comportamiento

#### Q4 · ¿Cuáles son las 10 páginas más visitadas?
```sql
SELECT
  ep.value.string_value AS pagina,
  COUNT(*) AS visitas
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS ep
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND ep.key = 'page_title'
GROUP BY pagina
ORDER BY visitas DESC
LIMIT 10
```
**Insight:** "Home" domina con 914,850 visitas. Destaca que "Shopping Cart" (195,006) y "Checkout Your Information" (110,781) aparecen en el top 10, indicando que una parte significativa del tráfico avanza en el proceso de compra.

---

#### Q5 · ¿Cuántos usuarios iniciaron sesión vs cuántos compraron?
```sql
SELECT
  event_name,
  COUNT(DISTINCT user_pseudo_id) AS usuarios
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name IN ('session_start', 'purchase')
GROUP BY event_name
ORDER BY usuarios DESC
```
**Insight:** De 267,116 usuarios que iniciaron sesión, solo 4,419 completaron una compra — una tasa de conversión aproximada de **1.65%**. Esto confirma una fuga significativa entre el inicio de sesión y la compra final.

---

#### Q6 · ¿Cuántos eventos ocurren en promedio por sesión?
```sql
WITH eventos_por_sesion AS (
  SELECT
    user_pseudo_id,
    ep.value.int_value AS session_id,
    COUNT(*) AS total_eventos
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(event_params) AS ep
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND ep.key = 'ga_session_id'
  GROUP BY user_pseudo_id, session_id
)
SELECT
  AVG(total_eventos) AS promedio_eventos_por_sesion
FROM eventos_por_sesion
```
**Insight:** Cada sesión genera en promedio **11.93 eventos**, indicando un nivel de interacción moderado-alto. Sin embargo, este engagement no se traduce en conversión proporcional según el funnel de Q5.

---

### Bloque 3 — Ecommerce

#### Q7 · ¿Cuánto revenue se generó por día?
```sql
SELECT
  event_date,
  SUM(ep.value.double_value) AS revenue_total
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS ep
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name = 'purchase'
  AND ep.key = 'value'
GROUP BY event_date
ORDER BY event_date ASC
```
**Insight:** Permite identificar los días de mayor venta y correlacionarlos con campañas activas o fechas clave del calendario comercial.

---

#### Q8 · ¿Qué productos se ven más vs cuáles se compran más?
```sql
SELECT
  event_name,
  item.item_name AS producto,
  COUNT(*) AS cantidad
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name IN ('view_item', 'purchase')
GROUP BY event_name, producto
ORDER BY event_name, cantidad DESC
LIMIT 20
```
**Insight:** El producto más comprado fue "Super G Unisex Joggers" (285 unidades). Comparar vistas vs compras por producto permite identificar cuáles tienen baja conversión a pesar de alto tráfico — oportunidad directa de optimización.

---

#### Q9 · ¿Cuánto gasta en promedio cada usuario?
```sql
SELECT
  user_pseudo_id AS usuario,
  AVG(ep.value.double_value) AS ticket_promedio
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS ep
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name = 'purchase'
  AND ep.key = 'value'
GROUP BY usuario
ORDER BY ticket_promedio DESC
```
**Insight:** Segmentar usuarios por ticket promedio permite identificar clientes de alto valor para estrategias de retención y fidelización (CRM).

---

### Bloque 4 — Análisis avanzado

#### Q10 · ¿Quiénes son los usuarios que más revenue generaron?
```sql
WITH revenue_por_usuario AS (
  SELECT
    user_pseudo_id AS usuario,
    SUM(ep.value.double_value) AS revenue_total
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(event_params) AS ep
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name = 'purchase'
    AND ep.key = 'value'
  GROUP BY usuario
)
SELECT
  usuario,
  revenue_total,
  RANK() OVER (ORDER BY revenue_total DESC) AS ranking
FROM revenue_por_usuario
LIMIT 20
```
**Insight:** Identifica los clientes de mayor valor (top spenders) del período analizado. Esta segmentación es la base de cualquier estrategia de retención, programa de fidelización o campaña de reactivación CRM.

---

## 💡 Conclusiones del análisis

- La tasa de conversión general es de **~1.65%**, con fugas claras entre `view_item` y `add_to_cart`
- El canal **orgánico domina** la adquisición; hay oportunidad de crecimiento en paid media
- El engagement por sesión es alto (**~12 eventos promedio**) pero no se traduce en compra
- Los productos con mayor volumen de vistas no siempre son los más comprados — oportunidad de optimización de producto y UX

---

## 👩‍💻 Autora
**Camila** · Marketing Analytics  
Proyecto desarrollado con BigQuery SQL sobre dataset público de GA4
