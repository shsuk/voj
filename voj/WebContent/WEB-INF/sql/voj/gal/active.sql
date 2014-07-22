UPDATE attach_tbl
SET
	active=case when active='Y' then 'N' else 'Y' end 
WHERE rid=@{rid};
	
