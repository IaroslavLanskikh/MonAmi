CREATE DATABASE IF NOT EXISTS dlq
COMMENT 'Dead Letter Queue, кладём данные не прошедшие через фильтры';

CREATE TABLE IF NOT EXISTS dlq.bronze_silver_dlq (
    event_date                       Date                             COMMENT 'Дата события по UTC-0',
    event_time                       DateTime                         COMMENT 'Дата и время события по UTC-0',
    user_id                          UInt64                           COMMENT 'Уникальный идентификатор посетителя сайта',
    watch_id                         UInt64                           COMMENT 'Уникальный идентификатор конкретного просмотра страницы (хита)',
    trafic_source_id                 Int8                             COMMENT 'Внутренний числовой код типа источника трафика (прямой заход, реклама и т.д.)',
    utm_source                       LowCardinality(String)           COMMENT 'UTM-метка источника трафика. Может содержать пустые строки',
    utm_medium                       LowCardinality(String)           COMMENT 'UTM-метка типа трафика',
    utm_campaign                     String                           COMMENT 'UTM-метка названия рекламной кампании',
    utm_content                      String                           COMMENT 'UTM-метка содержания объявления или дополнительной информации',
    utm_term                         String                           COMMENT 'UTM-метка ключевого слова или поисковой фразы из рекламы',
    referer                          String                           COMMENT 'Полный URL-адрес страницы, с которой пользователь перешел на текущую страницу',
    referer_domain                   LowCardinality(String)           COMMENT 'Домен страницы источника перехода (выделен из Referer)',
    search_frase                     String                           COMMENT 'Текст поискового запроса (если переход был из поисковой системы)',
    url                              String                           COMMENT 'Полный адрес просматриваемой страницы сайта',
    url_domain                       LowCardinality(String)           COMMENT 'Домен сайта, на котором происходит просмотр',
    region_id                        Int32                            COMMENT 'Числовой идентификатор географического региона пользователя',
    os                               Int16                            COMMENT 'Внутренний числовой идентификатор операционной системы',
    user_agent                       Int16                            COMMENT 'Внутренний числовой идентификатор браузера',
    is_mobile                        Boolean                          COMMENT 'Флаг типа устройства (1 — мобильное устройство, 0 — десктоп)',
    mobile_phone                     Int16                            COMMENT 'Числовой идентификатор производителя (бренда) мобильного телефона',
    mobile_phone_model               LowCardinality(String)           COMMENT 'Текстовое название модели устройства. Может содержать обрывки парсинга и пустые строки',
    resolution_width                 UInt16                           COMMENT 'Разрешение экрана устройства в пикселях по ширине',
    resolution_height                UInt16                           COMMENT 'Разрешение экрана устройства в пикселях по высоте',
    is_robot                         Int8                             COMMENT 'Флаг антифрод-системы (1 — визит совершен роботом, 0 — живым человеком)',
    is_not_bounce                    Boolean                          COMMENT 'Флаг «не-отказа» (1 — качественный визит, 0 — быстрый уход (отказ))',
    goals_reached                    Array(Int32)                     COMMENT 'Массив числовых идентификаторов целей, достигнутых в рамках хита. Например, пользователь добавил товар в корзину',
    param_order_id                   String                           COMMENT 'Номер оформленного заказа. Заполняется вместе с суммой при покупке',
    param_price                      UInt32                           COMMENT 'Сумма заказа. Заполняется только в момент совершения покупки на этой странице',
    _ingestion_time                  DateTime                         COMMENT 'Время записи данных в таблицу - бронзовый слой',
    _insert_into_dlq                 DateTime    DEFAULT now()        COMMENT 'Время записи данных в таблицу '
)
-- Движок 
ENGINE = MergeTree()
-- При необходимости скорректируйте в зависимости от объемов данных
PARTITION BY toYYYYMM(_ingestion_time)
-- При необходимости скорректируйте в зависимости от сценариев работы с таблицей
ORDER BY (event_date,user_id)
-- Время жизни данных
TTL _ingestion_time + INTERVAL 3 YEAR
-- Описание таблицы
COMMENT 'Dead Letter Queue, данные не прошедшие из bronze.ym_web_hits в silver.ym_web_hits из bronze'