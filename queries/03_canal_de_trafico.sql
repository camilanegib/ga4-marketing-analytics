SELECT
  traffic_source.medium AS canal,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos,
  COUNT(DISTINCT param.value.int_value) AS sesiones
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS param
WHERE param.key = 'ga_session_id'
GROUP BY canal
ORDER BY sesiones DESC
