UPDATE voj_gallery 
SET
	title=@{title},
	link_url = @{link_url}
WHERE gal_id=@{gal_id};
	
