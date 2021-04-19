create or replace function insert_after_deposits_fn() returns trigger language plpgsql as $$
	begin
		update accounts set
		account_balance = account_balance + new.deposit_amount
		where account_id = new.account_id;
		return new;
	end;
$$;

create trigger insert_after_deposits
after insert on deposits for each row
execute procedure insert_after_deposits_fn()
;
