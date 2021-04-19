drop function if exists deposit;
create or replace function deposit (
	operator int,
	account int,
	amount decimal(15, 2)
) returns table (
	deposit_id int,
	deposit_amount decimal(15, 2),
	deposit_time timestamp with time zone,
	account_id int,
	user_id int
) language plpgsql as $$
	declare
		current_deposit deposits%rowtype;
	begin
		if
			(
				select
					p.permission_id
				from
					permissions as p
				where
					p.user_id = operator and
					p.permission_action = 2
			)
			is not null
		then
			insert into deposits (deposit_amount, account_id, user_id)
			values (amount, account, operator)
			returning * into current_deposit;
			return query select *
			from deposits
			where deposits.deposit_id = current_deposit.deposit_id;
		else
			return query select * from deposits where deposits.deposit_id = 0;
		end if;
	end;
$$;
