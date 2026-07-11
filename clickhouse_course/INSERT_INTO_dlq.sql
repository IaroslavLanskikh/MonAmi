-- Шаблон запроса для очистки и трансформации данных (Бронза -> Карантин)
SELECT * 
    	, current_timestamp() _insert_into_dlq 
    	-- Время загрузки в Карантин / Можно засунуть в DDL таблицы в карантине
FROM bronze.ym_web_hits ywh
-- Разворачиваем запрос из основной части: NOT (filter)
WHERE NOT(1=1
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
)
  	  

