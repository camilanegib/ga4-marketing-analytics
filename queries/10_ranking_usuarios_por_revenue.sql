WITH revenue_por_usuario AS (
  SELECT
    user_pseudo_id AS usuario,
    SUM(ep.value.double_value) AS revenue_total
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(event_params) AS ep
  WHERE event_name = 'purchase'
    AND ep.key = 'value'
  GROUP BY usuario
)

SELECT
  usuario,
  revenue_total,
  RANK() OVER (ORDER BY revenue_total DESC) AS ranking
FROM revenue_por_usuario
LIMIT 20
