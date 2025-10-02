
-- number of cycles per user_id
select user_id, count(*) as cycles from cycles group by user_id order by user_id;

--number of cycles per username
select cycles.user_id, users.username, count(*) as cycles from users 
join cycles on users.user_id = cycles.user_id group by cycles.user_id, users.username order by cycles.user_id;

-- periods length
select cycle_id, end_date - start_date as period_length_days from cycles;

-- avg period length per user
select user_id, avg(end_date - start_date) as avg_length_days from cycles group by user_id order by user_id;

-- avg flow intensity per user
select user_id, avg(flow_intensity) as avg_flow from cycles group by user_id order by user_id;

-- select all users with abnormal flow (whose avg flow is less than 2 or greater than 4)
select cycles.user_id, users.username, avg(flow_intensity) as abnormal_flow 
from cycles join users on users.user_id = cycles.user_id 
group by cycles.user_id, users.username having avg(flow_intensity) > 4 or avg(flow_intensity) < 2 order by user_id;

-- select all users with excessive flow
select cycles.user_id, users.username, avg(flow_intensity) as excessive_flow
from cycles join users on users.user_id = cycles.user_id
group by cycles.user_id, users.username having avg(flow_intensity) > 4;

-- select all users with insuffecient flow
select cycles.user_id, users.username, avg(flow_intensity) as insufficient_flow
from cycles join users on users.user_id = cycles.user_id
group by cycles.user_id, users.username having avg(flow_intensity) < 2;

-- what are the ages of users with insufficient flow
select users.user_id, users.username, date_part('year', age(birthdate)) as age, avg(flow_intensity) as insuffecient_flow
from cycles join users on users.user_id = cycles.user_id
group by users.user_id, users.username, age having avg(flow_intensity) < 2;

-- what are the ages of users with esxcessive flow
select users.user_id, users.username, date_part('year', age(birthdate)) as age, avg(flow_intensity) as excessive_flow
from cycles join users on users.user_id = cycles.user_id
group by users.user_id, users.username, age having avg(flow_intensity) > 4;

-- 5 longest cycles 
select user_id, cycle_id, end_date - start_date as period_length_days from cycles
order by end_date - start_date desc limit 5;
-- shows that users 16, 22, and 9 have the longest period lenghts indicating that they may have irregularties in their mentrual cycles

-- 5 shortest cycles 
select user_id, cycle_id, end_date - start_date as period_length_days from cycles
order by end_date - start_date limit 5;
-- shows that users 7, 18 and 5 have the shortest period lengths indicatinf that they may have irrregularities in their menstrual cycles

-- users with heavy flow and long cycles;
select user_id, avg(end_date - start_date) as avg_length_days, avg(flow_intensity) as cycle_flow from cycles
group by user_id having avg(end_date - start_date) > 5 and avg(flow_intensity) > 3 order by user_id;

-- users with short cycles and very light flow;
select user_id, avg(end_date - start_date) as avg_length_days, avg(flow_intensity) as cycle_flow from cycles
group by user_id having avg(end_date - start_date) < 3 and avg(flow_intensity) < 3 order by user_id;

-- cycle length distribution
select (end_date - start_date) as period_length_days, count(*) as cycle_count from cycles
group by period_length_days order by period_length_days;
-- this shows that most periods last 3 to 5 days.

--average period lengths by age group
select 
       case 
            when date_part('year', age(birthdate)) between 16 and 20 then '20-25'
			when date_part('year', age(birthdate)) between 21 and 25 then '21-25'
			when date_part('year', age(birthdate)) between 26 and 30 then '26-30'
			when date_part('year', age(birthdate)) between 31 and 35 then '31-35'
			when date_part('year', age(birthdate)) between 36 and 40 then '36-40'
		end as age_group, 
avg(end_date - start_date) as avg_length_days
from users join cycles on users.user_id = cycles.user_id
group by age_group order by age_group; 

-- the percentage of cycles that fall under each flow intensity number
select flow_intensity, count(*) as cycle_count, round(100.0 * count(*) / (select count (*) from cycles), 2) as percentage
from cycles group by flow_intensity order by flow_intensity;
-- we can see that maximum percentage of cycles have the flow intesnity of 3

-- the shortest and longest period lengths of users 
select user_id, min(end_date - start_date) as shortest_periods, max(end_date - start_date) as longest_periods 
from cycles group by user_id order by user_id;

-- max and minimum flow for each user
select user_id, min(flow_intensity) as min_flow,  max(flow_intensity) as max_flow
from cycles group by user_id order by user_id;

-- this shows the percentage of users with abnormal flow in each age group
select 
       case 
            when date_part('year', age(birthdate)) between 16 and 20 then '20-25'
			when date_part('year', age(birthdate)) between 21 and 25 then '21-25'
			when date_part('year', age(birthdate)) between 26 and 30 then '26-30'
			when date_part('year', age(birthdate)) between 31 and 35 then '31-35'
			when date_part('year', age(birthdate)) between 36 and 40 then '36-40'
		end as age_group, sum(case when flow_intensity < 2 or flow_intensity > 4 then 1 else 0 end),
		round(100.0 * sum(case when flow_intensity < 2 or flow_intensity > 4 then 1 else 0 end) / count(*), 2) as abnormal_flow_percentage
from users join cycles on users.user_id = cycles.user_id 
group by age_group;

