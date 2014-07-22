SELECT 'code_tbl' tbl, count(mod_dt) chg_cnt
FROM code_tbl
WHERE mod_dt > to_date(:mod_dt, 'YYYY-MM-DD HH24:MI:SS ') 
UNION
SELECT 'lang_tbl' tbl, count(mod_dt) chg_cnt
FROM lang_tbl
WHERE mod_dt > to_date(:mod_dt, 'YYYY-MM-DD HH24:MI:SS ') 
UNION
SELECT 'workflow_tbl' tbl, count(mod_dt) chg_cnt
FROM workflow_tbl
WHERE mod_dt > to_date(:mod_dt, 'YYYY-MM-DD HH24:MI:SS ') 
UNION
SELECT 'workflow_process_tbl' tbl, count(mod_dt) chg_cnt
FROM workflow_process_tbl
WHERE mod_dt > to_date(:mod_dt, 'YYYY-MM-DD HH24:MI:SS ') 
UNION
SELECT 'menu_tbl' tbl, count(mod_dt) chg_cnt
FROM workflow_process_tbl
WHERE mod_dt > to_date(:mod_dt, 'YYYY-MM-DD HH24:MI:SS ') 
;