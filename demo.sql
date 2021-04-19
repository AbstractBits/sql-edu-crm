-- [PERMISSIONS]
-- set permission			0
-- view deposits			1
-- set deposit				2
-- view payments			3
-- set payment				4
-- view payment plan		5
-- create new user			6
-- create new user			7
-- create new group			8
-- create new lesson		9
-- create new quota			10
-- create new participant	11


-- [CREATE NEW USER]
-- operator (user_id)
-- username
-- password
-- firstname
-- lastname
-- gender
-- birthday
-- state_id
select new_user(
	1, 'username', 'password',
	'Firstname', 'Lastname',
	'M', '1994-04-01', 1
);


-- [SET PERMISSION]
-- operator (user_id)
-- user_id
-- action
-- set or unset
select set_permission(1, 2, 1, 1);


-- [LOGIN USER]
-- username
-- password
select login('muhammad', '1');

-- [CREATE NEW COURSE]
-- operator_id (user_id)
-- coursename
select * from new_course(1, 'Rust');

-- [CREATE NEW GROUP]
-- operator_id (user_id)
-- branch_id
-- price
-- course_id
-- teacher_id (user_id)
-- lessons_count
select * from new_group(1, 1, 10000000.00, 1, 1, 100);

-- [CREATE QUOTA FOR GROUP]
-- operator_id (user_id)
-- group_id
-- raise
select * from new_quota(1, 1, 20);

-- [CREATE NEW PARTICIPANT]
-- operator
-- role
-- initial_lesson
-- discount
-- quota_id
-- group_id
-- user_id
select * from new_participant(2, 2, 0, 0, null, 1, 4);

-- [CREATE NEW GROUP LESSON]
-- operator_id (user_id)
-- group_id
select * from new_lesson(2, 2);

-- [SET DEPOSIT]
-- operator_id (user_id)
-- account_id
-- amount
select * from deposit(1, 4, 100000);

-- [PAY FOR SERVICE]
-- operator_id (user_id)
-- type
-- reference_id
-- sender_account_id
-- receiver_account_id
-- payment_amount
select * from payment(1, 1, 1, 4, 2, 50000);

-- [GET ALL GROUPS || BY COURSE ID]
-- course_id 0...n (all groups when course_id = 0)
-- page
-- limit
select * from groups(0, 1, 20);

-- [GET GROUP'S PAYMENT PLAN]
-- operator_id (user_id)
-- group_id
select * from group_payment_plan(1,1);
