drop function if exists group_payment_plan;
create or replace function group_payment_plan (
	p_operator int,
	p_group_id int
) returns table (
	id int,
	fullname text,
	username character varying,
	account_id int,
	balance decimal(15, 2),
	raise smallint,
	discount smallint,
	lessons smallint,
	debt decimal(15, 2),
	plan decimal(15, 2),
	per_lesson decimal(15, 2),
	paid decimal(15, 2)
) language plpgsql as $$
	declare
		v_operator_id int := p_operator;
		v_group_id int := p_group_id;
	begin
		return query
		select
			p.participant_id as id,
			u.user_firstname || ' ' || u.user_lastname as fullname,
			u.user_username as username,
			a.account_id,
			a.account_balance as balance,
			q.quota_raise as raise,
			p.participant_discount as discount,
			-- lessons
			coalesce(
				t.lesson_count,
				g.group_completed_lessons
			) - p.participant_initial_lesson
			as lessons,
			(
				(
					-- lessons
					coalesce(
						t.lesson_count,
						g.group_completed_lessons
					) - p.participant_initial_lesson
				) * (
					-- per lesson
					(
						(
							g.group_price + g.group_price / 100 * coalesce(q.quota_raise, 0)
						) - g.group_price / 100 * p.participant_discount
					) / g.group_lessons
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
							p.group_id = g.group_id
					), 0
				)
			) as debt,
			(
				g.group_price + g.group_price / 100 * coalesce(q.quota_raise, 0)
			) - g.group_price / 100 * p.participant_discount
			as plan,
			(
				(
					g.group_price + g.group_price / 100 * coalesce(q.quota_raise, 0)
				) - g.group_price / 100 * p.participant_discount
			) / g.group_lessons as per_lesson,
			-- paid
			coalesce(
				(
					select sum(t.transfer_amount)
					from transfers as t
					join group_payments as p on p.transfer_id = t.transfer_id
					where
						t.sender_id = a.account_id and
						p.group_id = g.group_id
				), 0
			) as paid
		from participants as p
		left join group_transfers as t on t.participant_id = p.participant_id
		join users as u on u.user_id = p.user_id
		join accounts as a on a.user_id = p.user_id
		join groups as g on g.group_id = p.group_id
		left join quotas as q on q.quota_id = p.quota_id
		where
			g.group_completed_at is null and
			p.group_id = case when (
				select p.permission_id
				from permissions as p
				where
					p.user_id = v_operator_id and
					p.permission_action = 2
			) is not null then v_group_id else 0 end and
			p.participant_role = 2
		order by debt desc, left(u.user_firstname, 2);
	end;
$$;
