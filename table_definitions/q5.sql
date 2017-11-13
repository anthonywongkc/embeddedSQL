-- Committed

SET SEARCH_PATH TO parlgov;
drop table if exists q5 cascade;

-- You must not change this table definition.

CREATE TABLE q5(
        countryName VARCHAR(50),
        partyName VARCHAR(100),
        partyFamily VARCHAR(50),
        stateMarket REAL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS current_cabinet_party CASCADE;
DROP VIEW IF EXISTS shouldHaveBeen CASCADE;
DROP VIEW IF EXISTS committed_party CASCADE;
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
create view current_cabinet_party as
select cp.party_id as pid, cp.cabinet_id as cid, c.country_id
from cabinet c join cabinet_party cp on c.id = cp.cabinet_id
where date_part('year',c.start_date) >= 1997;

create view shouldHaveBeen as 
select p.id as pid, c.id as cid, p.country_id
from party p join cabinet c on p.country_id = c.country_id;

create view committed_party as
select id from party
except (
select distinct pid
from ((select * from shouldHaveBeen) 
	except 
	(select * from current_cabinet_party)) temp
);

create view intermediate_step as
select c.name as countryName, p.name as partyName, pf.family as partyFamily, pp.state_market as stateMarket
from committed_party cp, party p, country c, party_family pf, party_position pp
where cp.id = p.id and p.country_id = c.id and cp.id = pf.party_id and cp.id = pp.party_id;



-- the answer to the query 
insert into q5
select * from intermediate_step;
