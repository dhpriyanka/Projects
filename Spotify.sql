/*Spotify case study*/

/* 1.Find total active users each day*/
select event_date, count(distinct user_id) from activity
group by event_Date;

/* 2. Find total active users each week, week number, total_Active_users*/
select week(event_Date), count(distinct user_id) from activity
group by week(event_Date);

/* 3. Date wise total number of users who made the purchase same day they installed the app*/
select * from activity;
select count(distinct a_user_id) from (
select a.user_id a_user_id, a.event_name a_event_name, a.event_Date a_event_Date,  b.user_id b_user_id,b.event_name b_event_name, b.event_Date b_event_Date
from activity a join activity b
on a.user_id=b.user_id and a.event_name<>b.event_name
having a.event_Date=b.event_Date
order by a.user_id, a.event_Date) a;

with cte as (
select a.user_id a_user_id, a.event_name a_event_name, a.event_Date a_event_Date,  b.user_id b_user_id,b.event_name b_event_name, b.event_Date b_event_Date
from activity a join activity b
on a.user_id=b.user_id and a.event_name<>b.event_name
having a.event_Date=b.event_Date
order by a.user_id, a.event_Date)

select a_event_Date, count(distinct a_user_id) from cte
group by a_event_Date;

with cte as (
select user_id, event_Date,case when count(distinct event_name)=2 then 1 else 0 end as number_of from activity
group by user_id, event_Date
)

select event_Date, sum(number_of) from cte
group by event_Date;


/* 4. perentage of paid users in india , usa and any other country should be tagged as others country percentage_users*/
with cte as (
select * from activity
where event_name='app-purchase'),

cte2 as (
select country, round(count(*)/(select count(country) from cte)*100,2) as paid_users from cte
where event_name='app-purchase'
group by country)

select case when country in ("India","USA") then Country else 'Others' end country, sum(paid_users) from 
cte2
group by case when country in ("India","USA") then Country else 'Others' end;


/* 5. Among all the users who installed the app on a given day, how many did in app purchased on the very next day--day wise result*/
with cte as (
select user_id, date_add(event_Date, interval 1 day) from activity
where event_name='app-installed')

select event_date,count(user_id) from activity
where (user_id,event_Date) in  (
select user_id, date_add(event_Date, interval 1 day) from activity
where event_name='app-installed')
group by event_DAte;

select * from activity;

/* 2nd Solution */
select event_date,count(case when
 (user_id,event_Date) in  (
select user_id, date_add(event_Date, interval 1 day) from activity
where event_name='app-installed') then user_id else null end) cnt_users from activity
group by event_DAte;

with cte as (
select *, lag(event_name) over (partition by user_id order by event_Date) prev_event, 
lag(event_date) over (partition by user_id order by event_Date) prev_Date from activity
)

select event_date,count(case when  
prev_Date=event_date-1 and prev_Event='app-installed' and event_name='app-purchase' then user_id else null end) cnt_users 
from cte
group by event_date;


select *, lag(event_name) over (partition by user_id order by event_Date) prev_event, lag(event_date) over (partition by user_id order by event_Date) prev_Date from activity
