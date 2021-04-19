drop function if exists set_permission;
create or replace function set_permission (
	p_operator int,
	p_user_id int,
	p_action int,
	p_val int
) returns boolean language plpgsql as $$
	declare
		new_quota quotas%rowtype;
		v_operator int := p_operator;
		v_user_id int := p_user_id;
		v_action int := p_action;
		v_val int := p_val;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_operator and
					p.permission_action = 0
			)
			is not null
		then

			if v_val = 1 then

				insert into permissions
				(permission_action, user_id)
				values (v_action, v_user_id);

			else

				delete from permissions
				where user_id = v_user_id and
				permission_action = v_action;

			end if;

			return true;
		else
			return false;
		end if;
	end;
$$;
