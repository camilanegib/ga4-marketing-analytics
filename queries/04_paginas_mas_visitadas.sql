SELECT
  ep.value.string_value AS pagina,
  COUNT(*) AS visitas
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS ep
WHERE ep.key = 'page_title'
GROUP BY pagina
ORDER BY visitas DESC
LIMIT 10
