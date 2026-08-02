-- Замените переменные {} своими значениями без {}

CREATE MATERIALIZED VIEW IF NOT EXISTS etl.mv_silver_to_gold_users_daily_master
REFRESH EVERY 1 DAY
APPEND TO gold.users_daily_master
AS
SELECT

 event_date AS date,

 user_id,

 dictGet('dicts.trafic_source', 'trafic_source_name', argMax(trafic_source_id, event_time)) AS last_trafic_source_name,

 dictGet('dicts.hierarchy_region','region_name',argMin(region_id, event_time)) AS first_region_name,

 COUNT(watch_id) AS watch_cnt,

 SUM(param_price) AS sales,

 countIf(is_not_bounce = 1) AS not_bounce_visit_cnt,

 countIf(is_mobile = 1) AS is_mobile_visit_cnt,

 sumIf(param_price, is_mobile = 1) AS is_mobile_sales,

 groupUniqArray(url_domain) AS url_domains_list
FROM  silver.ym_web_hits AS ywh FINAL
WHERE event_date NOT IN (SELECT date FROM gold.users_daily_master AS udm)
GROUP BY

 event_date,

 user_id