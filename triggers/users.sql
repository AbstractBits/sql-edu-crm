create or replace function insert_after_users_fn() returns trigger language plpgsql as $$
	begin
		insert into accounts(user_id) values (new.user_id);
		return new;
	end;
$$;

create trigger insert_after_users
after insert on users for each row
execute procedure insert_after_users_fn()
;
