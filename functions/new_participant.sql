drop function if exists new_participant;
create or replace function new_participant (
	p_operator int,
	p_role int,
	p_il int,
	p_discount int,
	p_quota_id int,
	p_group_id int,
	p_user_id int
) returns boolean language plpgsql as $$
	declare
		v_operator int := p_operator;
		v_role int := p_role;
		v_il int := p_il;
		v_discount int := p_discount;
		v_quota_id int := p_quota_id;
		v_group_id int := p_group_id;
		v_user_id int := p_user_id;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_operator and
					p.permission_action = 11
			)
			is not null
		then
			insert into participants
			(participant_role, participant_initial_lesson, participant_discount, quota_id, group_id, user_id)
			values (v_role, v_il, v_discount, v_quota_id, v_group_id, v_user_id);

			return true;
		else
			return false;
		end if;
	end;
$$;
