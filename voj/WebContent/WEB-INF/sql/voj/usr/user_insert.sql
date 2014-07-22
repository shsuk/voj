INSERT INTO st_user_info (user_id, user_nm, pwd, nick_name, mb_email, village, mb_datetime)
VALUES (@{user_id}, @{user_nm}, password(@{pwd}), @{nick_name}, @{mb_email}, @{village}, now());
