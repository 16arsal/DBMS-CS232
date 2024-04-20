-- Create the adminusers table
CREATE TABLE adminusers (
    f_name VARCHAR NOT NULL,
    l_name VARCHAR,
    user_id INTEGER PRIMARY KEY NOT NULL,
    user_password VARCHAR NOT NULL,
    e_mail VARCHAR NOT NULL,
    phone_number NUMERIC(14) NOT NULL,
    branch_code INTEGER NOT NULL,
    user_type VARCHAR NOT NULL
);

-- Function to check user password
CREATE OR REPLACE FUNCTION check_pass(u_id INT, pass VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM adminusers
        WHERE user_id = u_id AND user_password = pass
    );
END;
$$ LANGUAGE plpgsql;

-- Function to create an adminuser
CREATE OR REPLACE FUNCTION create_adminuser(
    f_name VARCHAR,
    l_name VARCHAR,
    user_id INTEGER,
    user_password VARCHAR,
    e_mail VARCHAR,
    phone_number NUMERIC,
    branch_code INTEGER,
    user_type VARCHAR
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO adminusers VALUES (
        f_name, l_name, user_id, user_password, e_mail, phone_number, branch_code, user_type
    );
END;
$$ LANGUAGE plpgsql;



-- Create the branch table
CREATE TABLE branch (
    branch_code INTEGER PRIMARY KEY,
    city VARCHAR
);

-- Create the adminusers table
CREATE TABLE adminusers (
    f_name VARCHAR NOT NULL,
    l_name VARCHAR,
    user_id INTEGER PRIMARY KEY NOT NULL,
    user_password VARCHAR NOT NULL,
    e_mail VARCHAR NOT NULL,
    phone_number NUMERIC(14) NOT NULL,
    branch_code INTEGER NOT NULL REFERENCES branch(branch_code),
    user_type VARCHAR NOT NULL
);

-- Function to check user password
CREATE OR REPLACE FUNCTION check_pass(u_id INT, pass VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE 
    check_pass BOOLEAN;
BEGIN
    SELECT (user_password = pass) INTO check_pass
    FROM adminusers
    WHERE user_id = u_id;
    
    RETURN check_pass;
END;
$$ LANGUAGE plpgsql;

-- Drop the existing create_adminuser function
DROP FUNCTION IF EXISTS create_adminuser(character varying, character varying, integer, character varying, character varying, numeric, integer, character varying);

-- Recreate the create_adminuser function with corrected input parameter names
CREATE OR REPLACE FUNCTION create_adminuser(
    f_name_in VARCHAR,
    l_name_in VARCHAR,
    user_id_in INTEGER,
    user_password_in VARCHAR,
    e_mail_in VARCHAR,
    phone_number_in NUMERIC,
    branch_code_in INTEGER,
    user_type_in VARCHAR
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO adminusers VALUES (
        f_name_in, l_name_in, user_id_in, user_password_in, e_mail_in, phone_number_in, branch_code_in, user_type_in
    );
    RETURN;
END;
$$ LANGUAGE plpgsql;



-- Function to get user password
CREATE OR REPLACE FUNCTION get_pass(u_id INT)
RETURNS VARCHAR AS $$
DECLARE 
    user_pass VARCHAR;
BEGIN
    SELECT user_password INTO user_pass
    FROM adminusers
    WHERE user_id = u_id;
    
    RETURN user_pass;
END;
$$ LANGUAGE plpgsql;

-- Function to get user type
CREATE OR REPLACE FUNCTION get_type(u_id INT)
RETURNS VARCHAR AS $$
DECLARE 
    user_t VARCHAR;
BEGIN
    SELECT user_type INTO user_t
    FROM adminusers
    WHERE user_id = u_id;
    
    RETURN user_t;
END;
$$ LANGUAGE plpgsql;


create table products
(
	catogary varchar not null,
	prod_id int not null,
	price int not null,
	pro_type varchar not null,
	pro_location varchar not null,
	address varchar not null,
	p_size int not null,
 primary key(prod_id)
);


create table description 
(
	prod_id int,
	constraint fk_prod_id foreign key(prod_id) references products(prod_id),
	descrip varchar
)


create table customers
(
	username varchar not null,
	f_name varchar not null,
	l_name varchar not null,
	contact numeric(14) not null,
	email varchar not null,
	primary key(username)
)


drop table customers

create table customers
(
	user_id varchar not null primary key,
	f_name varchar not null,
	l_name varchar,
	contact numeric(14) not null,
	email varchar not null,
	pass varchar not null
)


CREATE FUNCTION GET_customers_PASS(U_ID varchar)
RETURNS VARCHAR AS $$
DECLARE 
	CHECK_PASS VARCHAR;
BEGIN
	SELECT pass into CHECK_PASS
	FROM customers
	where user_id = $1;
	return CHECK_PASS;
END;
$$  LANGUAGE plpgsql


create table products
(
	prod_id int not null primary key,
	catogary varchar not null,
	price int not null,
	pro_type varchar not null,
	pro_location varchar not null,
	address varchar not null,
	p_size int not null,
 description varchar,
	upload_from integer,
	constraint fk_prod_id foreign key(upload_from) references adminusers(user_id)
);


CREATE or REPLACE FUNCTION add_products(cat varchar, price integer, p_type varchar, p_loc varchar, address varchar, p_size integer, p_decription varchar)
RETURNS integer AS $$
DECLARE 
	p_id integer;
	cur_user integer;
BEGIN
	select count(prod_id) into p_id from products;
	select user_id into cur_user from current_login_user where c_id=1;
	insert into products values (p_id+1, cat, price, p_type, p_loc, address, p_size, p_decription, cur_user);
	return p_id;
END;
$$  LANGUAGE plpgsql


create table invoice
(
	branch_code integer not null references branch(branch_code),
	income integer,
	expences integer,
	upload_date DATE
);


create procedure add_invoice(branch_code integer, income integer, expences integer)
LANGUAGE SQL
as $$
  insert into invoice values (branch_code, income, expences, CURRENT_DATE);
$$;



create table backupadmin(fname varchar,user_id integer, e_mail varchar, phone numeric(14),branch_code integer);
create function move_del()
returns trigger
language plpgsql
as
$$
begin 
insert into backupadmin values (concat(old.f_name,' ',old.l_name),old.user_id,old.e_mail,old.phone_number,old.branch_code);
delete from adminusers
where old.user_id = new.user_id;
return new;
end;
$$

create table employees(ename varchar,eid integer primary key,brcode integer,salary integer);


create trigger movedata
after delete
on adminusers
for each row
execute function move_del();

create procedure paysal(b_id integer)
language plpgsql
as
$$
declare 
sum_Sal integer;
begin
select sum(salary) into sum_sal from employees where brcode = b_id;
call add_invoice(bid, sum_sal , 0);
end;
$$

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'products';

INSERT INTO products (prod_id, catogary, price, pro_type, pro_location, address, p_size)
VALUES
    (1, 'Shop', 10000, 'Rent', 'Islamabad', '456 Avenue Main Boulevard', 120),
    (2, 'Plot', 250000, 'Sale', 'Lahore', 'DHA Phase V Sector J', 5500),
    (3, 'Mall', 250000, 'Rent', 'Karachi', 'Tariq Road', 550000),
    (4, 'House', 40000, 'Sale', 'Lahore', 'Johar Town', 11000),
    (5, 'Shop', 34500, 'Rent', 'Islamabad', 'Centaurus', 300),
    (6, 'Plot', 50000, 'Sale', 'Kharian', 'Citi Housing', 11000);



alter table products
alter column price type numeric;

ALTER TABLE employees 
ADD CONSTRAINT constraint_name 
FOREIGN KEY (brcode) 
REFERENCES branch (branch_code);

ALTER TABLE backupadmin 
ADD CONSTRAINT constraint_name 
FOREIGN KEY (branch_code) 
REFERENCES branch (branch_code);

SELECT * FROM branch;
INSERT INTO branch (branch_code, city)
VALUES
    (1, 'Islamabad'),
    (2, 'Lahore'),
    (3, 'Kharian'),
    (4, 'Karachi')
;



insert into
invoice(branch_code,income,expences,upload_date)
values
(1,15000,2100,CURRENT_DATE),
(2,1000,12000,CURRENT_DATE),
(2,1500,1200,CURRENT_DATE),
(1,3500,4500,CURRENT_DATE),
(1,1400,1200,CURRENT_DATE);

INSERT INTO employees (ename, eid, brcode, salary)
VALUES
    ('Hassan', 1, 1, 20000),
    ('Ahmad', 2, 2, 40000),
    ('Yousaf', 3, 3, 55000), -- Use a different "brcode" value
    ('Zain', 4, 4, 76000),   -- Use a different "brcode" value
    ('Hussein', 5, 1, 81000), -- Choose a unique "eid" value
    ('Ilyas', 6, 2, 95000);


insert into
customers(user_id,f_name,l_name,contact,email,pass)
values
(1,'Ahmed','Ali',321543678,'ahmed@gmail.com','12347'),
(2,'Zain','Naufal',321213456,'zain@gmail.com','2343'),
(3,'Hassan','Ali',32154556565,'hassan@gmail.com','34322'),
(4,'Bilal','Qaiser',321544321,'bilal@gmail.com','12217'),
(5,'Farooq','Bajwa',321345556,'farooq@gmail.com','4567');



create table current_login_user(c_id integer, user_id integer REFERENCES adminusers(user_id), user_name varchar, branch_code integer REFERENCES branch(branch_code));


create procedure update_current_user(u_id integer)
language plpgsql
as
$$
declare 
b_code integer;
u_name varchar;
begin
select branch_code into b_code from adminusers where user_id = u_id;
select concat(f_name, ' ', l_name) into u_name from adminusers where user_id = u_id;
update current_login_user
set user_id = u_id,
	user_name = u_name,
	branch_code = b_code
where c_id = 1;
end;
$$


create view current_invoice as 
select * from invoice where branch_code = (select branch_code from current_login_user where c_id = 1);



