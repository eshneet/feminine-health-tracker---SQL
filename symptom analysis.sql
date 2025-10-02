-- all distinct symptoms
select distinct symptom from symptoms;

-- cycles percentage per symptom
select symptom, count(*) as cycle_count, 
round (100 * count(*) / (select count(*) from symptoms), 2) 
as percentage from symptoms group by symptom order by symptom;

-- least common symptoms; 
select symptom as least_common_symptoms,
count(*) as cycle_count 
from symptoms group by symptom order by count(*) limit 5;

-- most common symptoms; 
select symptom as most_common_symptoms,
count(*) as cycle_count 
from symptoms group by symptom order by count(*) desc limit 5;

-- users percentage per symptom
select symptom, count(distinct user_id),
round (100 * count(distinct user_id) / (select count(distinct user_id) from cycles), 2) as percentage 
from symptoms join cycles on cycles.cycle_id = symptoms.cycle_id 
group by symptom order by symptom;

--  symptoms of users 
select users.username, cycles.user_id, symptom, count(symptom) from 
users join cycles on users.user_id = cycles.user_id
      join symptoms on symptoms.cycle_id = cycles.cycle_id
group by cycles.user_id, username, symptom order by user_id;

-- users of which age group have most 'bloating'
select case 
            when date_part('year', age(birthdate)) between 16 and 20 then '16-20'
			when date_part('year', age(birthdate)) between 21 and 25 then '21-25'
			when date_part('year', age(birthdate)) between 26 and 30 then '26-30'
			when date_part('year', age(birthdate)) between 31 and 35 then '31-35'
			when date_part('year', age(birthdate)) between 36 and 40 then '36-40'
		end as age_group, count(distinct case when symptom = 'Bloating' then users.user_id else null end) as users_with_bloaitng
from users join cycles on users.user_id = cycles.user_id
		   join symptoms on cycles.cycle_id = symptoms.cycle_id 
group by age_group 
order by count(distinct case when symptom = 'Bloating' then users.user_id else null end) desc limit 1;

-- age groups showing users with bloating and long cycles
select case 
            when date_part('year', age(birthdate)) between 16 and 20 then '16-20'
			when date_part('year', age(birthdate)) between 21 and 25 then '21-25'
			when date_part('year', age(birthdate)) between 26 and 30 then '26-30'
			when date_part('year', age(birthdate)) between 31 and 35 then '31-35'
			when date_part('year', age(birthdate)) between 36 and 40 then '36-40'
		end as age_group, 
count(distinct case when symptom = 'Bloating' then users.user_id else null end) as users_with_bloating,
count(distinct case when cycles.end_date - cycles.start_date > 4 then cycles.user_id else null end) as long_cycles
from users join cycles on users.user_id = cycles.user_id
		   join symptoms on cycles.cycle_id = symptoms.cycle_id 
group by age_group order by age_group;

-- users with long cycles, heavy flow and the symptom bloating on high severity 
select users.username, cycles.user_id, max(end_date - start_date) as long_cycles, max(flow_intensity) as flow_rate, max(severity) bloating_severity, symptoms.symptom
from users join cycles on users.user_id = cycles.user_id
join symptoms on cycles.cycle_id = symptoms.cycle_id
group by cycles.user_id, username, symptom having symptoms.symptom = 'Bloating';

-- average cycle length for each symptom
select avg(end_date - start_date) as avg_periods_length, symptoms.symptom from cycles join symptoms
on cycles.cycle_id = symptoms.cycle_id 
group by symptoms.symptom order by avg(end_date - start_date) desc;

-- users with normal cycle length regular flow and mild cramps
select distinct users.username, users.user_id from
users join cycles on users.user_id = cycles.user_id
join symptoms on cycles.cycle_id = symptoms.cycle_id
where end_date - start_date in (3, 4, 5) and flow_intensity in (2, 3) and symptom = 'Mild cramps'
order by user_id;

--average severity of symptom in cycles
select avg(severity) as avg_severity, cycle_id from symptoms group by cycle_id order by cycle_id;

-- which user's which cycle has maximum severity of each symptom
select users.username, cycles.cycle_id, severity, symptoms.symptom from symptoms join 
(select symptom, max(severity) as max_severity from symptoms group by symptom) as max_s
on symptoms.symptom = max_s.symptom and symptoms.severity = max_s.max_severity
join cycles on cycles.cycle_id = symptoms.cycle_id
join users on users.user_id = cycles.user_id 
order by symptoms.symptom;