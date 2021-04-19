drop function if exists groups;
create or replace function groups (
	p_course_id int,
	p_page int,
	p_limit int
) returns table (
	id int,
	lessons text,
	course character varying,
	debt decimal(15, 2),
	branch character varying
) language plpgsql as $$
	declare
		v_course_id int := p_course_id;
		v_page int := p_page;
		v_limit int := p_limit;
	begin
		return query
		select
			g.group_id as id,
			g.group_lessons::character varying || '/' ||
			group_completed_lessons::character varying as lessons,
			c.course_name as course,
			(
				select
					sum(
						(
							(
								-- lessons
								coalesce(
									t.lesson_count,
									sg.group_completed_lessons
								) - p.participant_initial_lesson
							) * (
								-- per lesson
								(
									(
										sg.group_price + g.group_price / 100 * coalesce(q.quota_raise, 0)
									) - sg.group_price / 100 * p.participant_discount
								) / sg.group_lessons
							)
						) - (
							-- paid
							coalesce(
								(
									select sum(t.transfer_amount)
									from transfers as t
									join group_payments as p on p.transfer_id = t.transfer_id
									where
										t.sender_id = a.account_id and
										p.group_id = sg.group_id
								), 0
							)
						)
					)
				from participants as p
				left join group_transfers as t on t.participant_id = p.participant_id
				join accounts as a on a.user_id = p.user_id
				left join groups as sg on sg.group_id = p.group_id
				left join quotas as q on q.quota_id = p.quota_id
				where
					p.participant_role = 2 and
					sg.group_id = g.group_id

			) debt,

			b.branch_name as branch
		from
			groups as g
		join
			courses as c on c.course_id = g.course_id
		join
			branches as b on b.branch_id = g.branch_id
		where
			c.course_id between
				case when v_course_id = 0 then 1 else v_course_id end and
				case when v_course_id = 0 then (
					select max(group_id)
					from groups
				) else v_course_id end and
			g.group_completed_at is null
		order by debt
		offset (v_page - 1) * v_limit limit v_limit
		;
	end;
$$;
