-- Замените переменные {} своими значениями без {}

INSERT INTO bronze.ym_web_hits
(
    -- Перечисляем только те поля, в которые планируется загрузка данных
	event_date,
	event_time,
	user_id,
	watch_id,
	trafic_source_id,
	utm_source,
	utm_medium,
	utm_campaign,
	utm_content,
	utm_term,
	referer,
	referer_domain,
	search_frase,
	url,
	url_domain,
	region_id,
	os,
	user_agent,
	is_mobile,
	mobile_phone,
	mobile_phone_model,
	resolution_width,
	resolution_height,
	is_robot,
	is_not_bounce,
	goals_reached,
	param_order_id,
	param_price
)
SELECT
    -- Перечисляем колонки в том порядке, как в таблице.
	EventDate,
	EventTime,
	UserID,
	WatchID,
	TraficSourceID,
	UTMSource,
	UTMMedium,
	UTMCampaign,
	UTMContent,
	UTMTerm,
	Referer,
	RefererDomain,
	SearchPhrase,
	URL,
	URLDomain,
	RegionID,
	OS,
	UserAgent,
	IsMobile,
	MobilePhone,
	MobilePhoneModel,
	ResolutionWidth,
	ResolutionHeight,
	IsRobot,
	IsNotBounce,
	GoalsReached,
	ParamOrderID,
	ParamPrice
FROM url(
    -- Две точки ".." означают диапазон ОТ и ДО
    -- Пример ссылки https://huggingface.co/datasets/ivannatarov/clickhouse_course/resolve/main/hits_2013_week_{45..50}.csv
	'https://huggingface.co/datasets/ivannatarov/clickhouse_course/resolve/main/hits_2013_week_{45..47}.csv',
    'CSVWithNames'
)
SETTINGS
    -- Разрешаем перенаправления (нужно для S3/HuggingFace)
    max_http_get_redirects = 10,
    -- Пишем пачками по 100к строк, экономим ресурсы RAM
    max_insert_block_size = 100000