-- Новый скрипт в localhost.
-- Дата: 19 июл. 2026 г.
-- Время: 20:53:24
-- Замените переменные {} своими значениями без {}
CREATE DICTIONARY IF NOT EXISTS dicts.trafic_source ( 
    trafic_source_id Int8,
    -- Атрибуты справочника
    trafic_source_type String,
    trafic_source_name String
)
PRIMARY KEY trafic_source_id

-- Источник данных словаря (загрузка файла по HTTP с удаленного сервера)
SOURCE(HTTP(
    -- Пример ссылки 'https://huggingface.co/datasets/ivannatarov/clickhouse_course/raw/main/dictionaries/trafic_source.txt'
    URL 'https://huggingface.co/datasets/ivannatarov/clickhouse_course/raw/main/dictionaries/trafic_source.txt' 
    FORMAT 'TSVWithNames'
))

-- Настройка регулярного обновления (в секундах)
LIFETIME(MIN 300 MAX 600)

-- Настройка размещения в оперативной памяти
LAYOUT(COMPLEX_KEY_HASHED())

-- Описание словаря
COMMENT 'Словарь, содержит источники трафика: ID источника, тип, название';