SELECT

 event_date AS date,

 user_id,

 argMax(trafic_source_id, event_time) AS last_trafic_source_id,

 argMin(region_id, event_time) AS first_region_id,

 COUNT(watch_id) AS watch_cnt,

 SUM(param_price) AS sales,

 countIf(is_not_bounce = 1) AS not_bounce_visit_cnt,

 countIf(is_mobile = 1) AS is_mobile_visit_cnt,

 sumIf(param_price, is_mobile = 1) AS is_mobile_sales,

 groupUniqArray(url_domain) AS url_domains_list
FROM  silver.ym_web_hits AS ywh FINAL
GROUP BY

 event_date,

 user_id