SELECT
  event_name,
  COUNT(DISTINCT user_pseudo_id) AS usuarios
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name IN ('session_start', 'purchase')
GROUP BY event_name
ORDER BY usuarios DESC
