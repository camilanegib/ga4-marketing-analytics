SELECT
  event_date,
  SUM(ep.value.double_value) AS revenue_total
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS ep
WHERE event_name = 'purchase'
  AND ep.key = 'value'
GROUP BY event_date
ORDER BY event_date ASC
