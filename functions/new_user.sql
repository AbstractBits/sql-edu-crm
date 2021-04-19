drop function if exists new_user;
create or replace function new_user (
	p_user_id int,
	p_username varchar,
	p_password varchar,
	p_firstname varchar,
	p_lastname varchar,
	p_gender gender,
	p_birthday date,
	p_state_id int
) returns table (
	user_id int,
	user_username character varying,
	user_password character varying,
	user_firstname character varying,
	user_lastname character varying,
	user_gender gender,
	user_birthday date,
	state_id int,
	user_is_active boolean,
	user_created_at timestamp with time zone
) language plpgsql as $$
	declare
		new_user users%rowtype;
		v_user_id int		:= p_user_id;
		v_username varchar	:= p_username;
		v_password varchar	:= p_password;
		v_firstname varchar	:= p_firstname;
		v_lastname varchar	:= p_lastname;
		v_gender gender		:= p_gender;
		v_birthday date		:= p_birthday;
		v_state_id int		:= p_state_id;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_user_id and
					p.permission_action = 6
			)
			is not null or (
				select count(users.user_id)
				from users
			) = 0
		then

			insert into users
			(
				user_username,
				user_password,
				user_firstname,
				user_lastname,
				user_gender,
				user_birthday,
				state_id
			) values (
				v_username,
				crypt(v_password, gen_salt('bf')),
				v_firstname,
				v_lastname,
				v_gender,
				v_birthday,
				v_state_id) returning
				*
			into new_user;

			return query
				select
					*
				from users
				where
					users.user_id = new_user.user_id;
		else
			return query select * from users where users.user_id = 0;
		end if;
	end;
$$;
