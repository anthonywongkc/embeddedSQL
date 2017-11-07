-- Winners

SET SEARCH_PATH TO parlgov;
drop table if exists q2 cascade;

-- You must not change this table definition.

create table q2(
countryName VARCHaR(100),
partyName VARCHaR(100),
partyFamily VARCHaR(100),
wonElections INT,
mostRecentlyWonElectionId INT,
mostRecentlyWonElectionYear INT
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS parties_and_elections CASCADE;
DROP VIEW IF EXISTS full_party_info CASCADE;

-- All parties and their elections
CREATE VIEW parties_and_elections AS (
	SELECT c.name as country_name, c.id as country_id, p.name as party_name, p.id as party_id,
    		 er.election_id, er.seats,e_date as election_date
    FROM country c, party p, election e, election_result er
    WHERE c.id = p.country_id and  e.id = er.election_id and p.id = er.party_id
);  

-- Every winning party
CREATE VIEW winning_parties as (
	SELECT party_name, party_id, seats, election_id, country_name, country_id, election_date
    FROM  parties_and_elections p
    WHERE p.seats = (select max(p2.seats)
                    from parties_and_elections p2
                    where p.election_id = p2.election_id)
); 

-- Full information for every winning party
Create View full_party_info as (
    SELECT wins, wins.party_name,wins.party_id, winners_recent_id.election_id as most_recent, least_recent , country_name, country_id
    FROM
       (SELECT count(*) as wins, party_name,party_id,  min(election_date) as least_recent , country_name, country_id
        FROM winning_parties
        GROUP BY party_name, party_id,country_name, country_id ) wins,
       (SELECT party_name, election_id
        FROM winning_parties wp
        WHERE wp.election_id =
        (--getting the most recent won election's id
        SELECT election_id as most_recent
        FROM winning_parties wp2
        WHERE wp2.party_name = wp.party_name
        ORDER BY party_name, election_date DESC
        LIMIT 1
        )) winners_recent_id
    WHERE wins.party_name = winners_recent_id.party_name
);
  
-- join with party family at the end, since we don;t want it to contribute to the averages

insert into q2 
(SELECT country_name as countryName, party_name as partyName, party_family.family as partyFamily, 
		wins as wonElections, most_recent as mostRecentlyWonElectionId, date_part('year',least_recent) as mostRecentlyWonElectionYear
FROM
      (SELECT *
          FROM full_party_info
          WHERE wins >
          (
          Select (3*(winners.wins/total_parties.total::float)) as avg
          FROM
          (select count(*)as wins, country_id from election group by country_id)winners,
          (select count(*)as total, country_id from party group by country_id) total_parties
          WHERE winners.country_id = total_parties.country_id and winners.country_id = full_party_info.country_id
          )
      )more_then_average left join party_family on more_then_average.party_id = party_family.party_id);

