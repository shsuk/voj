
SELECT *
FROM voj_vod
WHERE vod_id= @{vod_id}
	and '${session.myGroups[req.bd_cat]}'='true' 
;
