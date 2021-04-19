drop function if exists new_lesson;
create or replace function new_lesson (
	p_user_id int,
	p_group_id int
) returns table (id int) language plpgsql as $$
	declare
		new_lesson lessons%rowtype;
		v_user_id int := p_user_id;
		v_group_id int := p_group_id;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_user_id and
					p.permission_action = 9
			)
			is not null or (
				select groups.user_id
				from groups
				where groups.group_id = v_group_id
			) = v_user_id
		then
			insert into lessons
			(lesson_started_at, group_id)
			values (current_timestamp, v_group_id)
			returning * into new_lesson;

			return query
				select lesson_id as id from lessons
				where lessons.lesson_id = new_lesson.lesson_id;
		else
			return query select lesson_id as id from lessons where lessons.lesson_id = 0;
		end if;
	end;
$$;
