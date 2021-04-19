drop function if exists payment;
create or replace function payment (
	operator int,
	type int,
	ref int,
	sender int,
	receiver int,
	amount decimal(15, 2)
) returns table (
	transfer_id int,
	transfer_amount decimal(15, 2),
	transfer_time timestamp with time zone,
	sender_id int,
	receiver_id int
) language plpgsql as $$
	declare
		current_transfer transfers%rowtype;
	begin
		if (
			(
				select
					u.user_id
				from
					accounts as a
				join
					users as u on u.user_id = a.user_id
				where
					a.account_id = sender
				) = operator or (
					select
						p.permission_id
					from
						permissions as p
					where
						p.user_id = operator and
						p.permission_action = 4
				) is not null
			) and (
				select
					account_balance - amount
				from
					accounts
				where
					account_id = sender
			) >= 0
		then
			insert into transfers (sender_id, receiver_id, transfer_amount)
			values (sender, receiver, amount)
			returning * into current_transfer;
			if type = 1 then
				insert into group_payments(transfer_id, group_id)
				values (current_transfer.transfer_id, ref);
			end if;
			return query select *
			from transfers
			where transfers.transfer_id = current_transfer.transfer_id;
		else
			return query select * from transfers where transfers.transfer_id = 0;
		end if;
	end;
$$;
