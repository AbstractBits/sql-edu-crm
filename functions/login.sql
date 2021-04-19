drop function if exists login;
create or replace function login (
	p_username character varying,
	p_password character varying
) returns int language plpgsql as $$
	declare
		login_user users%rowtype;
		v_username varchar := p_username;
		v_password varchar := p_password;
	begin
		select
			u.user_id
		from
			users as u
		where
			u.user_username = v_username and
			u.user_password = crypt(v_password, u.user_password)
		into login_user;

		if login_user is null then

			return 0;

		end if;

		return login_user.user_id;

	end;
$$;
