-- Шаблон запроса для очистки и трансформации данных (Бронза -> Серебро)
-- Из Бронзы не забираем: is_robot, _ingestion_time
CREATE MATERIALIZED VIEW IF NOT EXISTS etl.mv_bronze_to_silver_hits
TO silver.ym_web_hits
AS
SELECT
    toDate(event_time)                              AS event_date,
    event_time                                      AS event_time,
    user_id                                         AS user_id,
    watch_id                                        AS watch_id,
    trafic_source_id                                AS trafic_source_id,
    lower(trim(utm_source))                         AS utm_source,
    lower(trim(utm_medium))                         AS utm_medium,
    lower(trim(utm_campaign))                       AS utm_campaign,
    lower(trim(utm_content))                        AS utm_content,
    lower(trim(utm_term))                           AS utm_term,
    trim(referer)                                   AS referer,
    lower(trim(domain(referer)))                    AS referer_domain,
    search_frase                                    AS search_frase,
    trim(url)                                       AS url,
    lower(trim(domain(url)))                        AS url_domain,
    region_id                                       AS region_id,
    os                                              AS os,
    user_agent                                      AS user_agent,
    is_mobile                                       AS is_mobile,
    mobile_phone                                    AS mobile_phone,
    lower(trim(mobile_phone_model))                 AS mobile_phone_model,
    resolution_width                                AS resolution_width,
    resolution_height                               AS resolution_height,
    is_not_bounce                                   AS is_not_bounce,
    goals_reached                                   AS goals_reached,
    lower(trim(param_order_id))                     AS param_order_id,
    param_price                                     AS param_price,
    current_timestamp()                             AS _insert_into_silver,
    lower(trim(_source_system))                     AS _source_system
FROM bronze.ym_web_hits ywh
WHERE 1=1
    AND is_robot = 0
    AND region_id != 0
    AND user_id != 0
    AND watch_id != 0
    AND _source_system != ''
    AND event_date != '1970-01-01'
    AND event_time != '1970-01-01 00:00:00'
    AND _ingestion_time != '1970-01-01 00:00:00'
    AND (
        (is_mobile = FALSE AND mobile_phone = 0 AND mobile_phone_model = '')
        OR
        (is_mobile = TRUE AND mobile_phone != 0 AND mobile_phone_model != '')
    )
    AND resolution_width > 1
    AND resolution_height > 1
    AND is_not_bounce IN (0, 1)
    AND trafic_source_id BETWEEN -1 AND 10
    AND url != ''
    AND (
        (param_price = 0 AND param_order_id = '')
        OR
        (param_price > 0 AND param_order_id != '')
    );