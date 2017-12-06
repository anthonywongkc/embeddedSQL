-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
create view intermediate_step as
select c.name as name, date_part('year',e.e_date) as year, avg(e.votes_cast/e.electorate::float) as ratio
from election e join country c on e.country_id = c.id
where e.country_id = c.id and date_part('year',e.e_date) >= 2001 and date_part('year',e.e_date) <= 2016
group by c.name, date_part('year',e.e_date);


-- the answer to the query 
insert into q3
select name, year, ratio
from intermediate_step
where name not in (
select i1.name
from intermediate_step i1, intermediate_step i2
where i1.name = i2.name and i1.year < i2.year and i1.ratio > i2.ratio);

