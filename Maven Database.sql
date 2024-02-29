DELIMITER //
create procedure Gettititleoffilm(in filmid int)
begin
select title from film where film_id=filmId;
end//
delimiter ;

call Gettititleoffilm(1);

DELIMITER //
CREATE PROCEDURE Getfilmtitlesforrating (in input_rating varchar(10))
begin
 select *from film where rating=input_rating;
 end //
 delimiter ;
 
 -- call Getfilmtitlesforrating("PG");
 
--  write a stored procedure that takes first letter of customers first name as argument and
-- the country as the second argument and returns all those customers
-- Example GetCustomerDetails('A', 'India') : All customer details from India whose name starts with A

delimiter //
create procedure GetCustomerDetailsof(in Firstcharacter varchar(1), IN Countryname varchar(20))
begin
select * from customer join address using (address_id)
join city using (city_id)
join country using (country_id)
where first_name like concat(Firstcharacter,"%") and country=Countryname;
end//
delimiter ;

call GetCustomerDetailsof("M", "India");


create index idx_release_year on film(release_year);
alter table film drop index idx_release_year;

create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);

insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;
select * from airbnb_searches;

CREATE TABLE emp_salary1
(
emp_id INTEGER  NOT NULL,
    name VARCHAR(20)  NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);

INSERT INTO emp_salary1
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

use ankit_bansal;
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);

create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);

insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');

select * from Ameriprise_LLC;

with cte as (
select * from Ameriprise_LLC where criteria1 = 'Y' and criteria2='Y')

select teamid, count(memberid) from cte
where  criteria1 = 'Y' and criteria2='Y'
group by teamid
having count(memberid)>=2;

create table family 
(
person varchar(5),
type varchar(10),
age int
);
delete from family ;
insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);

select * from  family;

create table company_revenue 
(
company varchar(100),
year int,
revenue int
);

insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);

select * from company_revenue;
-- Find the company only whose revenue is increasing every year
-- note: suppose a company revenue is increasing for 3 years and a very next year 
-- revenue is dipped in that case it should not come in output

with cte as (
select *, lag(revenue) over (partition by company order by year) 1_lag,
revenue-lag(revenue,1,0) over (partition by company order by year) difference,
count(1) over (partition by company) cnt  from company_revenue
),
cte2 as (
select company, cnt, count(1) c from cte
where difference>0
group by company, cnt)

select company from cte2
where cnt=c;
-- select company from cte where revenue>1_lag and 1_lag>2_lag




with cte as (
select *, lag(revenue) over (partition by company order by year) 1_lag,
revenue-lag(revenue,1,0) over (partition by company order by year) difference,
count(1) over (partition by company) cnt  from company_revenue
)

select distinct company from cte
where company not in (select company from cte where difference<0);

create table people
(id int primary key not null,
 name varchar(20),
 gender char(2));

create table relations
(
    c_id int,
    p_id int,
    FOREIGN KEY (c_id) REFERENCES people(id),
    foreign key (p_id) references people(id)
);

insert into people (id, name, gender)
values
    (107,'Days','F'),
    (145,'Hawbaker','M'),
    (155,'Hansel','F'),
    (202,'Blackston','M'),
    (227,'Criss','F'),
    (278,'Keffer','M'),
    (305,'Canty','M'),
    (329,'Mozingo','M'),
    (425,'Nolf','M'),
    (534,'Waugh','M'),
    (586,'Tong','M'),
    (618,'Dimartino','M'),
    (747,'Beane','M'),
    (878,'Chatmon','F'),
    (904,'Hansard','F');
    
    insert into relations (c_id, p_id)values
    (145, 202),
    (145, 107),
    (278,305),
    (278,155),
    (329, 425),
    (329,227),
    (534,586),
    (534,878),
    (618,747),
    (618,904);

select * from people;
select * from relations;

with cte as (
select a.c_id, a.p_id, b.name as parent_name,if(b.gender='M', 'Father','Mother') relation
from  people b join relations a on a.p_id=b.id),
cte2 as (
select c.c_id, c.p_id,b.name as kids_name from relations c join people b
on c.c_id=b.id)


select kids_name,max(case when relation="Father" then parent_name end) as Father, 
max(case when relation="Mother" then parent_name end ) as mother
from cte join cte2
on cte.p_id=cte2.p_id
group by kids_name;

with cte as (
select r.c_id,p.name as mother_name from relations r join people p
on r.p_id=p.id 
where gender="F"),

cte2 as (
select r.c_id,p.name as father_name from relations r join people p
on r.p_id=p.id 
where gender="M"),

cte3 as (
select cte.c_id, mother_name, father_name from cte join cte2
on cte.c_id=cte2.c_id)

select p.name as kids_name, mother_name, father_name 
from cte3 join people p
on cte3.c_id=p.id;

with cte as (
select r.c_id,max(p.name) as mother_name, max(p1.name) as father_name
from relations r left join people p on r.p_id=p.id and p.gender="F"
left join people p1 on r.p_id=p1.id and p1.gender="M"
group by r.c_id)

select p.name as kids_name, mother_name, father_name from cte join people p
 on cte.c_id=p.id;
 

 
 create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ'),
(2,'PAK','NED','PAK'),
(3,'AFG','BAN','BAN'),
(4,'SA','SL','SA'),
(5,'AUS','IND','IND'),
(6,'NZ','NED','NZ'),
(7,'ENG','BAN','ENG'),
(8,'SL','PAK','PAK'),
(9,'AFG','IND','IND'),
(10,'SA','AUS','SA'),
(11,'BAN','NZ','NZ'),
(12,'PAK','IND','IND'),
(12,'SA','IND','DRAW');

select * from icc_world_cup;
with cte as (
select team, sum(c) total_matches_played from (
select team_1 as team, count(*) c from icc_world_cup group by team_1
union all
select team_2 as team, count(*) c from icc_world_cup group by team_2) a
group by team),
 
 cte2 as (
 select winner, count(*) as win  from icc_world_cup group by winner)
 
select  team,total_matches_played,ifnull(win,0) win, total_matches_played-ifnull(win,0) as loss, ifnull(win,0)*2 points from cte left join cte2
on cte.team=cte2.winner



-- select * , total_matches_played-win as loss, win*2 as points from cte2
