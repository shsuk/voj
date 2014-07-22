SELECT *
FROM workflow_process_tbl 
WHERE use_yn = 'Y'
ORDER BY wf_id, order_no
