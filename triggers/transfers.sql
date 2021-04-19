create or replace function insert_after_transfers_fn() returns trigger language plpgsql as $$
	begin
		update accounts set
		account_balance = account_balance - new.transfer_amount
		where account_id = new.sender_id;
		return new;
	end;
$$;

create trigger insert_after_transfers
after insert on transfers for each row
execute procedure insert_after_transfers_fn()
;
