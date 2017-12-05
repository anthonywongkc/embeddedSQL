-- Alliances

SET SEARCH_PATH TO parlgov;
drop table if exists q7 cascade;

-- You must not change this table definition.

DROP TABLE IF EXISTS q7 CASCADE;
CREATE TABLE q7(
        countryId INT, 
        alliedPartyId1 INT, 
        alliedPartyId2 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
-- DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS electionNum CASCADE;
DROP VIEW IF EXISTS all_pairs CASCADE;
DROP VIEW IF EXISTS ratio CASCADE;

-- Define views for your intermediate steps here.
create view electionNum as
select country_id, count(*)
from election
group by country_id;

create view all_pairs as 
select e1.party_id as party1, e2.party_id as party2, e.country_id, count(distinct e1.election_id) as numOfAllied
from election_result e1, election_result e2, election e
where e1.election_id = e2.election_id and e.id = e1.election_id and e.id = e2.election_id and e1.party_id < e2.party_id 
and (e1.alliance_id = e2.alliance_id or e1.alliance_id = e2.id or e1.id = e2.alliance_id)
group by e.country_id, e1.party_id, e2.party_id;

create view ratio as 
select p.country_id, p.party1, p.party2
from all_pairs p join electionNum e on p.country_id = e.country_id
where p.numOfAllied/e.count::float*100 >= 30;


-- the answer to the query 
insert into q7 select * from ratio;
