drop function if exists new_quota;
create or replace function new_quota (
	p_user_id int,
	p_group_id int,
	p_raise int
) returns table (id int) language plpgsql as $$
	declare
		new_quota quotas%rowtype;
		v_user_id int := p_user_id;
		v_group_id int := p_group_id;
		v_raise smallint := p_raise;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_user_id and
					p.permission_action = 10
			)
			is not null
		then
			insert into quotas
			(quota_raise, group_id)
			values (v_raise, v_group_id)
			returning * into new_quota;

			return query
				select quota_id as id from quotas
				where quotas.quota_id = new_quota.quota_id;
		else
			return query select quota_id as id from quotas where quotas.quota_id = 0;
		end if;
	end;
$$;
