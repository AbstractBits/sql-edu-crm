drop function if exists get_users;
create or replace function get_users (
	p_page int,
	p_limit int
) returns table (
	id users.user_id%type,
	student boolean,
	account_id accounts.account_id%type,
	username users.user_username%type,
	fullname text,
	gender gender,
	birthday users.user_birthday%type,
	age double precision,
	state states.state_name%type,
	since int2
) language plpgsql as $$
	declare
		v_page int := p_page;
		v_limit int := p_limit;
	begin
		return query
		select
			u.user_id as id,
			(
				select count(participant_id)
				from participants
				where user_id = u.user_id
			) > 0 as student,
			a.account_id as account_id,
			u.user_username as username,
			u.user_firstname || ' ' || u.user_lastname as fullname,
			u.user_gender as gender,
			u.user_birthday as birthday,
			extract(year from current_date)
			- extract(year from u.user_birthday) as age,
			s.state_name as state,
			to_char(u.user_created_at, 'YYYY')::int2 as since
		from users as u
		left join accounts as a using(user_id)
		join states as s using(state_id)
		order by since desc, fullname
		offset (v_page - 1) * v_limit limit v_limit
		;
	end
$$;
