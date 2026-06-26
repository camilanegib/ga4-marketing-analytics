SELECT
  user_pseudo_id AS usuario,
  AVG(ep.value.double_value) AS ticket_promedio
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(event_params) AS ep
WHERE event_name = 'purchase'
  AND ep.key = 'value'
GROUP BY usuario
ORDER BY ticket_promedio DESC
