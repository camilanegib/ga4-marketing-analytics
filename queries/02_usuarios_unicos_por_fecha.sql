SELECT
  event_date,
  COUNT(DISTINCT user_pseudo_id) AS usuarios_unicos
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_date
ORDER BY event_date ASC
