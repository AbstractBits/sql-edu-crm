drop function if exists new_course;
create or replace function new_course (
	p_user_id int,
	p_coursename varchar
) returns table (
	id int,
	name character varying
) language plpgsql as $$
	declare
		new_course courses%rowtype;
		v_user_id int := p_user_id;
		v_coursename varchar := p_coursename;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = v_user_id and
					p.permission_action = 7
			)
			is not null
		then

			insert into courses
			(course_name) values (v_coursename)
			returning * into new_course;

			return query
				select * from courses
				where courses.course_id = new_course.course_id;
		else
			return query select * from courses where courses.course_id = 0;
		end if;
	end;
$$;
