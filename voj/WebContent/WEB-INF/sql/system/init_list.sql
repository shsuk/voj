SELECT
	'code' kind,
	count(*) chg_count,
	date_format(now(), '%Y-%m-%d %H:%i:%s') check_date
FROM code_tbl
JOIN init_config_tbl ON code_ato_init = 'Y'
WHERE mod_dt > str_to_date(@{mod_dt}, '%Y-%m-%d %H:%i:%s')

union

SELECT
	'lang' kind,
	count(*) chg_count,
	date_format(now(), '%Y-%m-%d %H:%i:%s') check_date
FROM lang_tbl
JOIN init_config_tbl ON lang_ato_init = 'Y'
WHERE mod_dt > str_to_date(@{mod_dt}, '%Y-%m-%d %H:%i:%s')

union

SELECT
	'schedule' kind,
	count(*) chg_count,
	date_format(now(), '%Y-%m-%d %H:%i:%s') check_date
FROM schedule_tbl
JOIN init_config_tbl ON schedule_ato_init = 'Y'
WHERE mod_dt > str_to_date(@{mod_dt}, '%Y-%m-%d %H:%i:%s')

union

SELECT
	'menu' kind,
	count(*) chg_count,
	date_format(now(), '%Y-%m-%d %H:%i:%s') check_date
FROM menu_tbl
JOIN init_config_tbl ON menu_ato_init = 'Y'
WHERE mod_dt > str_to_date(@{mod_dt}, '%Y-%m-%d %H:%i:%s')

union

SELECT
	kind,
	sum(chg_count) chg_count,
	date_format(now(), '%Y-%m-%d %H:%i:%s') check_date
FROM (
	SELECT
		'workflow' kind,
		count(*) chg_count
	FROM workflow_tbl
	JOIN init_config_tbl ON workflow_ato_init = 'Y'
	WHERE mod_dt > str_to_date(@{mod_dt}, '%Y-%m-%d %H:%i:%s')
) a
GROUP BY kind
;