drop function if exists new_group;
create or replace function new_group (
	p_user_id int,
	p_branch_id int,
	p_price decimal(15, 2),
	p_course_id int,
	p_teacher_id int,
	p_lessons int
) returns table (
	id int
) language plpgsql as $$
	declare
		new_group groups%rowtype;
		v_branch_id int := p_branch_id;
		v_user_id int := p_user_id;
		v_price decimal := p_price;
		v_course_id int := p_course_id;
		v_teacher_id int := p_teacher_id;
		v_lessons smallint := p_lessons;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_user_id and
					p.permission_action = 8
			)
			is not null
		then

			insert into groups
			(branch_id, group_price, course_id, user_id, group_lessons)
			values (v_branch_id, v_price, v_course_id, p_teacher_id, v_lessons)
			returning * into new_group;

			return query
				select group_id as id from groups
				where groups.group_id = new_group.group_id;
		else
			return query select group_id as id from groups where groups.group_id = 0;
		end if;
	end;
$$;
