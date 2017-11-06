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
--DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS countries_parties CASCADE;
DROP VIEW IF EXISTS past_elections CASCADE;
DROP VIEW IF EXISTS party_results CASCADE;
-- Define views for your intermediate steps here.

-- combine parties and their countries  ->
CREATE VIEW countries_parties AS (
	SELECT country.name as country_name, country.id as country_id, party.name as party_name, party.id as party_id 
	FROM country join party on country.id = party.country_id
);

-- link the parties and xountries to the elections in the past 10 years -> pay attention to joins
CREATE VIEW past_elections AS (
      SELECT 
      FROM countries_parties Cp join election e on Cp.country_id = e.country_id
 );

-- now sync up those parties in those elections with their results  -> pay attention to no voters
 CREATE VIEW party_results AS (
      SELECT pe.country_name, pe.country_id, pe.party_name, pe.party_id, pe.election_date, er.votes 
      FROM past_elections pe join election_result er on pe.election_id = er.election_id and pe.party_id = er.party_id 
  );


-- the answer to the query 
insert into q1 

