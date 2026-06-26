 📊 GA4 Marketing Analytics — SQL Portfolio

Proyecto de análisis de datos sobre comportamiento de usuarios y conversión,
desarrollado con SQL en Google BigQuery sobre un dataset público de GA4.

Período analizado: noviembre 2020 – enero 2021  
Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

---

 Herramientas utilizadas

- Google BigQuery
- SQL (CTEs, window functions, UNNEST, aggregations)
- GitHub

---

```
## Estructura del proyecto
ga4-marketing-analytics/
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
└── README.md
```
 Qué analicé

Desarrollé 10 consultas organizadas en 4 bloques temáticos:

Tráfico y exploración — qué eventos ocurren más, cuántos usuarios llegan
por día y por qué canal.

Comportamiento — qué páginas visitan, cuántos avanzan hacia la compra
y qué tan activos son dentro de cada sesión.

Ecommerce — revenue diario, qué productos se ven vs cuáles se compran,
y cuánto gasta en promedio cada usuario.

Análisis avanzado — ranking de usuarios por revenue total generado,
usando window functions (RANK).

---

  Principales hallazgos

- La tasa de conversión sesión → compra es de aproximadamente 1.65%
- Hay una caída brusca entre `view_item` y `add_to_cart`, lo que indica
  una fuga temprana en el funnel
- El canal orgánico domina la adquisición; paid media (CPC) es el más bajo
  y representa una oportunidad de crecimiento
- Los productos más vistos no siempre son los más comprados

Autora
Camila · Marketing Analytics
