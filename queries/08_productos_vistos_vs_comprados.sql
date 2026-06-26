SELECT
  event_name,
  item.item_name AS producto,
  COUNT(*) AS cantidad
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS item
WHERE event_name IN ('view_item', 'purchase')
GROUP BY event_name, producto
ORDER BY event_name, cantidad DESC
LIMIT 20
