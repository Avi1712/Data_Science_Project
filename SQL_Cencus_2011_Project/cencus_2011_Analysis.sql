show databases;
use world;
select * from census_part1;
select * from census_part2;

-- no of rows present in our data sets 
select count(*) as total_rows
from census_part1;

select count(*) as 'total_rows'
from census_part2;

-- select data from bihar and jharkhand
select * 
from census_part1
where State in ('Bihar','Jharkhand');

-- populuation of India
select  sum(Population) as 'population of india' 
from census_part2;

-- avg growth percentage state wise
select State , avg(growth) as growth_percentage
from census_part1
group by State;

-- avg sex ratio state wise ,where highest sex ratio on the top ,and avg sex ratio should not have decimal values
select State , round(avg(Sex_Ratio)) as 'avg_Sex_ratio'
from census_part1
group by State
order by avg_Sex_ratio desc;

-- states name have avg literacy rate more than 90 percent
select State , avg(Literacy) as avgerage_literacy
from census_part1
group by State 
having avgerage_literacy >90
order by avgerage_literacy desc;

-- top 3 state have highest avg growth rate 
select State , round(avg(growth)) as growth_rate
from census_part1
group by State 
order by growth_rate desc limit 3;

-- bottom 3 states have lowest avg sex ratio
select State , round(avg(Sex_Ratio)) as avgerage_Sex_ratio
from census_part1
group by State
order by avgerage_Sex_ratio asc limit 3;

-- top and bottom 3 states in literacy rate
DROP TABLE  IF EXISTS topstates;
create table topstates
( states varchar(50),
  Literacy float
);

Insert into topstates ( select State  , round (avg(Literacy)) as avg_literacy 
from census_part1
group by State
order by  avg_literacy desc );

select * from topstates;

DROP TABLE  IF EXISTS bottomstates;
create table bottomstates
( states varchar(50),
  Literacy float
);

Insert into bottomstates ( select State  , round (avg(Literacy)) as avg_literacy 
from census_part1
group by State
order by  avg_literacy Asc );

select * from bottomstates;

-- top and bottom 3 states in literacy rate  
(select states , Literacy 
from topstates limit 3)
union
(select states , Literacy 
from bottomstates limit 3);

-- states starting with letter a 
select distinct State
from census_part1
where lower(State) like 'a%';

-- state with start with letter a and ending with letter m
select distinct State 
from census_part1
where lower(State) like 'a%m';

-- district , state , total population , and avg sex ratio 
-- joining both table
select  a.State , round( sum(b.Population)) as total_population
from census_part1 as a 
Join census_part2 b
on a.State = b.State
group by a.State ;

--  female/male = sex ratio
-- female = sex ratio * male
-- male +female = population
-- male + sex ratio * male = population
-- male = population/(1 + sex ratio)

-- population of male and female state wise

select  a.State , round( sum(b.Population)/(1 +  avg(a.Sex_Ratio))) as male , 
round(  sum(b.Population)/(1 +  avg(a.Sex_Ratio))*avg(a.Sex_Ratio) ) as female 
from census_part1 as a 
Join census_part2 b
on a.State = b.State
group by a.State ;

select sum(Population)
from census_part2
where State in ('Andhra Pradesh');

SELECT SUM(Population)
FROM census_part2
WHERE TRIM(State) = 'Andhra Pradesh';


