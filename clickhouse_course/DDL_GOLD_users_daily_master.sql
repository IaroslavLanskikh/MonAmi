-- Новый скрипт в localhost.
-- Дата: 26 июл. 2026 г.
-- Время: 20:40:32
-- Замените переменные {} своими значениями без {}

-- Создание Мастер-витрины в Золотом слое 
CREATE TABLE IF NOT EXISTS gold.users_daily_master (
 -- Измерения (Dimensions)
 date Date COMMENT 'Дата события по UTC-0',
 user_id UInt64 COMMENT 'Уникальный идентификатор посетителя сайта',
 last_trafic_source_name String COMMENT 'Последний актуальный источник трафика пользователя за день',
 first_region_name String COMMENT 'Первый зафиксированный регион пользователя за ден',
 -- Меры (Measures)
 watch_cnt UInt16 COMMENT 'Общее количество хитов',
 sales UInt32 COMMENT 'Сумма всех покупок',
 not_bounce_visit_cnt UInt16 COMMENT 'Количество неотказных визитов',
 is_mobile_visit_cnt UInt16 COMMENT 'Количество визитов с мобильных устройств',
 is_mobile_sales UInt32 COMMENT 'Сумма покупок только для мобильных устройств',
 url_domains_list Array(String) COMMENT 'Все уникальные домены, которые посетил пользователь за день',
 -- Технические поля (Meta)
 _calculated_time DateTime DEFAULT now() COMMENT 'Время расчета и записи строки'

)
-- Стандартный движок для аналитических запросов без фоновой дедупликации
ENGINE = MergeTree()
-- При необходимости скорректируйте в зависимости от объемов данных
PARTITION BY toYYYYMM(_calculated_time)
-- Укажите поля строго в порядке частоты их использования при фильтрации
ORDER BY

 (date, last_trafic_source_name, first_region_name)
-- Время жизни данных (привязано строго к бизнес-дате)
COMMENT 'Мастер витрина - содержит данные в разрезе дня по пользователям: последний источник трафика, первый регион, посещения, продажи';