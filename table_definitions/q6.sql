-- Sequences

SET SEARCH_PATH TO parlgov;
drop table if exists q6 cascade;

-- You must not change this table definition.

CREATE TABLE q6(
        countryName VARCHAR(50),
        cabinetId INT, 
        startDate DATE,
        endDate DATE,
        pmParty VARCHAR(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

DROP VIEW IF EXISTS all_cabinets CASCADE;
DROP VIEW IF EXISTS leading_party CASCADE;
DROP VIEW IF EXISTS dates CASCADE;

-- Define views for your intermediate steps here.
Create View all_cabinets as (
  SELECT c2.name as CountryName, c2.id as Country_ID, c1.id as cabinetId, 
          c1.start_date as startDate, c1.name as cabinet_name,        
          c1.election_id, c1.previous_cabinet_id
  FROM cabinet c1 left join country c2 on c1.country_id = c2.id
);
  
Create View leading_party as (
  SELECT top_party.cabinetId, party.name as pmParty
  FROM
      (SELECT ac.cabinetId, party_id
      FROM all_cabinets ac , cabinet_party cp
      WHERE cp.cabinet_id = ac.cabinetId and cp.pm = true)top_party, party
  WHERE top_party.party_id = party.id
);
  
Create view dates as (
  SELECT a1.cabinetId, a1.startDate, a2.startDate as endDate
  from all_cabinets a1 left join all_cabinets a2 on a2.previous_cabinet_id = a1.cabinetId
);


-- the answer to the query 
insert into q6 
SELECT ac.countryName, ac.cabinetID, ac.startDate, d.endDate, lp.pmParty
FROM  all_cabinets ac
	LEFT JOIN leading_party lp on ac.cabinetID = lp.cabinetId
	LEFT JOIN dates d on ac.cabinetId = d.cabinetId
