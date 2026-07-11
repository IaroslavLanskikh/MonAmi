-- Шаблон запроса для очистки и трансформации данных (Бронза -> Серебро)
SELECT *
    EXCEPT (
        is_robot,
        _ingestion_time
    )
    REPLACE (
        toDate(event_time) AS event_date,
        
        -- регистрозависимые — только trim
	    trim(referer)      AS referer,
	    trim(search_frase) AS search_frase,
	    trim(url)          AS url,
	
	    -- остальные строковые — lower + trim
	    lower(trim(utm_source))        AS utm_source,
	    lower(trim(utm_medium))        AS utm_medium,
	    lower(trim(utm_campaign))      AS utm_campaign,
	    lower(trim(utm_content))       AS utm_content,
	    lower(trim(utm_term))          AS utm_term,
	    lower(trim(domain(referer)))    AS referer_domain,
	    lower(trim(domain(url)))        AS url_domain,
	    lower(trim(mobile_phone_model)) AS mobile_phone_model,
	    lower(trim(param_order_id))    AS param_order_id,
	    lower(trim(_source_system))    AS _source_system
    ),
    current_timestamp() AS _insert_into_silver 
    -- Время загрузки в Серебро / Можно засунуть в DDL таблицы в серебре
FROM bronze.ym_web_hits ywh
WHERE 1=1
  AND is_robot = 0
  AND region_id != 0
  AND user_id != 0
  AND watch_id != 0
  -- У колонки и так стоит ограничение NOT NULL 
  AND _source_system != ''
  AND event_date != '1970-01-01'
  AND event_time != '1970-01-01 00:00:00'
  AND _ingestion_time != '1970-01-01 00:00:00'
  AND (
  		(is_mobile = FALSE AND mobile_phone = 0 AND mobile_phone_model  = '') 
   		OR 
   		(is_mobile = True AND mobile_phone != 0 AND mobile_phone_model  != '')
   		)
  AND resolution_width > 1
  AND resolution_height > 1
  -- Вопрос к условию, у нас ведь is_not_bounce - Bool
  AND is_not_bounce IN (0,1)
  AND trafic_source_id BETWEEN -1 AND 10
  AND url != ''
  AND (
	  	(param_price = 0 AND param_order_id = '')
	  	OR 
	  	(param_price > 0 AND param_order_id != '')
  		)

  	  

