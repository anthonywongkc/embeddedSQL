-- VoteRange

SET SEARCH_PATH TO parlgov;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
year INT,
countryName VARCHAR(50),
voteRange VARCHAR(20),
partyName VARCHAR(100)
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
-- DROP VIEW IF EXISTS countries_parties CASCADE;
-- DROP VIEW IF EXISTS past_elections CASCADE;
-- DROP VIEW IF EXISTS party_results CASCADE;
-- -- Define views for your intermediate steps here.

-- -- combine parties and their countries  ->
-- CREATE VIEW countries_parties AS (
-- 	SELECT country.name as country_name, country.id as country_id, party.name as party_name, party.id as party_id 
-- 	FROM country join party on country.id = party.country_id
-- );

-- -- link the parties and xountries to the elections in the past 10 years -> pay attention to joins
-- CREATE VIEW past_elections AS (
--       SELECT 
--       FROM countries_parties Cp join election e on Cp.country_id = e.country_id
--  );

-- -- now sync up those parties in those elections with their results  -> pay attention to no voters
--  CREATE VIEW party_results AS (
--       SELECT pe.country_name, pe.country_id, pe.party_name, pe.party_id, pe.election_date, er.votes 
--       FROM past_elections pe join election_result er on pe.election_id = er.election_id and pe.party_id = er.party_id 
--   );


-- -- the answer to the query 
-- insert into q1 


create view intermediate_step as
select c.name as countryName, p.name_short as partyName, date_part('year',e.e_date) as year, avg(er.votes/e.votes_valid::float*100) as percentage
from country c, party p, election e, election_result er
where c.id = e.country_id and e.id = er.election_id and p.id = er.party_id and date_part('year',e_date) >= 1996 and date_part('year',e_date) <= 2016
group by countryName, partyName, year;



-- the answer to the query 
insert into q1 (year, countryName, voteRange, partyName)
select year, countryName, '(0,5]', partyName 
from intermediate_step
where percentage > 0 and percentage <= 5;

insert into q1 (year, countryName, voteRange, partyName)
select year, countryName, '(5,10]', partyName 
from intermediate_step
where percentage > 5 and percentage <= 10;

insert into q1 (year, countryName, voteRange, partyName)
select year, countryName, '(10,20]', partyName 
from intermediate_step
where percentage > 10 and percentage <= 20;

insert into q1 (year, countryName, voteRange, partyName)
select year, countryName, '(20,30]', partyName 
from intermediate_step
where percentage > 20 and percentage <= 30;

insert into q1 (year, countryName, voteRange, partyName)
select year, countryName, '(30,40]', partyName 
from intermediate_step
where percentage > 30 and percentage <= 40;

insert into q1 (year, countryName, voteRange, partyName)
select year, countryName, '(40,100]', partyName 
from intermediate_step
where percentage > 40 and percentage <= 100;

