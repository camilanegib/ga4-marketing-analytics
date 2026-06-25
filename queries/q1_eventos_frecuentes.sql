SELECT
  event_name,
  COUNT(*) AS numero_eventos
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
ORDER BY numero_eventos DESC
LIMIT 10
