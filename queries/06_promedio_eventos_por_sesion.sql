WITH eventos_por_sesion AS (
  SELECT
    user_pseudo_id,
    ep.value.int_value AS session_id,
    COUNT(*) AS total_eventos
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(event_params) AS ep
  WHERE ep.key = 'ga_session_id'
  GROUP BY user_pseudo_id, session_id
)

SELECT
  AVG(total_eventos) AS promedio_eventos_por_sesion
FROM eventos_por_sesion
