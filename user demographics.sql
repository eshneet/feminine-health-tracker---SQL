-- user demographics; AGE
select username, date_part('year', age(birthdate)) as age 
from users;
--grouping users by AGE 
select date_part('year', age(birthdate)) as age, count (*) as users_count from users group by age order by age;
