DELETE FROM voj_vod_reply
WHERE vod_id=@{vod_id} ;

DELETE FROM voj_vod
WHERE vod_id=@{vod_id};