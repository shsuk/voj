/*
 {key:'grow',singleRow="true"}
 */
SELECT sum(cnt) cnt, min(b_hour) b_hour
FROM ( 
	SELECT count(*) cnt, ifnull(min(TIMESTAMPDIFF(hour, reg_dt, NOW())),99999) b_hour
	FROM voj_gallery 
	WHERE bd_cat='voj' and reg_dt > DATE_SUB(now(),INTERVAL 1 DAY)  
	union
	SELECT count(*) cnt, ifnull(min(TIMESTAMPDIFF(hour, t1.reg_dt, NOW())),99999) b_hour
	FROM voj_gallery_reply t1
	INNER JOIN voj_gallery t2 ON t1.gal_id = t2.gal_id  and bd_cat='voj' 
	WHERE t1.reg_dt > DATE_SUB(now(),INTERVAL 1 DAY)  
) x1;
/*
 {key:'crow',singleRow="true"}
 */
SELECT sum(cnt) cnt, min(b_hour) b_hour
FROM ( 
	SELECT count(*) cnt, ifnull(min(TIMESTAMPDIFF(hour, reg_dt, NOW())),99999) b_hour
	FROM voj_board 
	WHERE bd_cat='cafe' and reg_dt > DATE_SUB(now(),INTERVAL 1 DAY) 
	union
	SELECT count(*) cnt, ifnull(min(TIMESTAMPDIFF(hour, t1.reg_dt, NOW())),99999) b_hour
	FROM voj_board_reply t1
	INNER JOIN voj_board t2 ON t1.bd_id = t2.bd_id and bd_cat='cafe' 
	WHERE t1.reg_dt > DATE_SUB(now(),INTERVAL 1 DAY)  
) x1;

/*
 {key:'vrow',singleRow="true"}
 */
SELECT sum(cnt) cnt, min(b_hour) b_hour
FROM ( 
	SELECT count(*) cnt, ifnull(min(TIMESTAMPDIFF(hour, reg_dt, NOW())),99999) b_hour
	FROM voj_board 
	WHERE bd_cat='vil' and reg_dt > DATE_SUB(now(),INTERVAL 1 DAY) 
	union
	SELECT count(*) cnt, ifnull(min(TIMESTAMPDIFF(hour, t1.reg_dt, NOW())),99999) b_hour
	FROM voj_board_reply t1
	INNER JOIN voj_board t2 ON t1.bd_id = t2.bd_id and bd_cat='vil' 
	WHERE t1.reg_dt > DATE_SUB(now(),INTERVAL 1 DAY) 
) x1;
