-- Новый скрипт в localhost.
-- Дата: 19 июл. 2026 г.
-- Время: 21:00:20
-- Замените переменные {} своими значениями без {}
CREATE DICTIONARY IF NOT EXISTS dicts.hierarchy_region (
 region_id Int32,
 -- Атрибуты справочника
 federal_district String,
 region_name String,
 city_name String,
 settlement_type String
)
PRIMARY KEY region_id

-- Источник данных словаря (загрузка файла по HTTP с удаленного сервера)
SOURCE(HTTP(
 -- Пример ссылки 'https://huggingface.co/datasets/ivannatarov/clickhouse_course/raw/main/dictionaries/trafic_source.txt'
 URL 'https://huggingface.co/datasets/ivannatarov/clickhouse_course/raw/main/dictionaries/regions.txt'
 FORMAT 'TSVWithNames'
))

-- Настройка регулярного обновления (в секундах)
LIFETIME(MIN 300 MAX 600)

-- Настройка размещения в оперативной памяти
LAYOUT(COMPLEX_KEY_HASHED())

-- Описание словаря
COMMENT 'Словарь, содержит гео иерархию городов РФ. ID региона, название федерального округа, название региона, название населенного пункта, тип населенного пункта';