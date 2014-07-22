delete valid_tbl 
where query_id = @{_q} and col_id = @{sub.col_id};

insert into valid_tbl (rid, query_id, col_id, valid, func, width)
values(sid.nextval, @{_q}, @{sub.col_id}, @{sub.valid}, @{sub.func}, @{sub.width});