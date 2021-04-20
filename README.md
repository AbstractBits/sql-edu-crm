# sql-edu-crm
CRM system for Najot Ta'lim (written in SQL)

## Create User

```sql
	select * from new_user(
		1, 						-- Operator int ref users (user_id)
		'username',				-- Username varchar
		'password',				-- Password varchar
		'First Name',			-- Firstname varchar
		'Last Name',			-- Lastname varchar
		'M',					-- Gender enum(M || F)
		'1994-04-01',			-- Birth date
		1						-- State int ref states(state_id)
	)
```

## List Of Users (with pagination)

```sql
select get_users(
	1,	-- CurrentPage int (for pagination)
	20,	-- Limit int (for pagination)
);
```

## Permissions

+ 0 SET PERMISSION
+ 1 VIEW DEPOSITS
+ 2 SET DEPOSIT
+ 3 VIEW PAYMENTS
+ 4 SET PAYMENT
+ 5 VIEW PAYMENT PLAN (STUDENTS IN GROUP)
+ 6 CREATE NEW USER
+ 7 CREATE NEW COURSE
+ 8 CREATE NEW GROUP
+ 9 CREATE NEW LESSON
+ 10 SET QUOTA FOR GROUP
+ 11 CREATE NEW PARTICIPANT (TEACHER, STUDENT, etc)

## Set Permission

```sql
	select set_permission(
		1,	-- Operator int ref users (user_id)
		2,	-- User int ref users (user_id)
		1,	-- Action smallint (example: 1 = view deposits)
		1	-- Rights smallint (1 = SET, 0 = UNSET) [delete row on rights = 0]
	)
```

## Login User

```sql
	select * from login(
		'username', -- Username varchar
		'password'	-- Password varchar
	)
```

## Create Course

```sql
	select * from new_course(
		1,						-- Operator int ref users (user_id)
		'Back-End Development'	-- Coursename varchar
	)
```

## Create Group

```sql
	select * from new_group(
		1,				-- Operator int ref users (user_id)
		1,				-- Branch int ref branches (branch_id)
		12000000.00,	-- Price decimal(15,2)
		1,				-- Course int ref courses (course_id)
		1,				-- Teacher int ref users (user_id)
		80				-- LessonsCount smallint
	)
```

## Set Quota For Group (raise)

```sql
	select * from new_quota(
		1,	-- Operator int ref users (user_id)
		1,	-- Group int ref groups (group_id)
		15	-- Raise smallint (group_price / 100 * 15)
	)
```

## Create Participant

```sql
	select * from new_participant(
		1,		-- Operator int ref users (user_id)
		2,		-- Role smallint (1 = teacher, 2 = student)
		0,		-- InitialLesson smallint (lesson started at...)
		10,		-- Discount smallint (group_price - (group_price / 100 * 10))
		null,	-- Quota int (raise)
		1,		-- Group int ref groups (group_id)
		2		-- Participant int ref users (user_id)
	)
```

## Create Lesson

```sql
	select * from new_lesson(
		1,	-- Operator int ref users (user_id)
		1	-- Group int ref groups (group_id)
	)
```

## Set Deposit

```sql
	select * from deposit(
		1,			-- Operator int ref users (user_id)
		2,			-- Account int ref accounts (account_id)
		600000.00	-- Amount decimal(15, 2)
	)
```

## Pay For Service

```sql
	select * from payment(
		1,			-- Operator int ref users (user_id)
		1,			-- Type smallint (1 = pay for course)
		102,		-- Ref int (pay for group 102) [group_id, etc]
		2,			-- Payer int ref accounts (account_id)
		1,			-- Receiver int ref accounts (account_id) [merchant_account]
		200000.00	-- Amount decimal(15, 2)
	)
```

## List Of Groups

```sql
	select * from groups(
		1,	-- Course int (or 0 for all groups)
		1,	-- Page int (for pagination)
		20,	-- Limit int (for pagination)
	)
```


## View Payment Plan For Group

```sql
	select * from group_payment_plan(
		1,	-- Operator int ref users (user_id)
		1	-- Group int ref groups (group_id)
	)
```
