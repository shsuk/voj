
/*
 {key:'rows'}
 */
SELECT *
FROM mc_bible 
WHERE 
	${empty(req.nevi) ? '' : '--'} mc_dt = @{mc_dt}
	${req.nevi=='a' ? '' : '--'}   mc_dt > @{mc_dt}
	${req.nevi=='b' ? '' : '--'}   mc_dt < @{mc_dt}
ORDER BY mc_dt ${req.nevi=='a' ? '' : 'desc'} , ca_name
LIMIT 0,4
;