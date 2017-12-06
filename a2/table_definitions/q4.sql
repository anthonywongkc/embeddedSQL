-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS parties_and_policy CASCADE;

-- Define views for your intermediate steps here.
CREATE VIEW parties_and_policy AS (
SELECT p.name, c.name as countryName, pp.left_right
FROM party p 
	left join party_position pp  on p.id = pp.party_id 
	left join country c on p.country_id = c.id

);

-- the answer to the query 
--INSERT INTO q4 
INSERT into q4
SELECT t1.countryName, t1.r0_2, t2.r2_4, t3.r4_6, t4.r6_8, t5.r8_10
FROM
	(Select p.countryName, count(*) as r0_2, Null as r2_4, Null as r4_6, Null as r6_8, Null as r8_10
	FROM parties_and_policy p
	WHERE  0 <= p.left_right  and p.left_right < 2
	Group by p.countryName) t1, 
	(Select p.countryName, Null as r0_2, count(*) as r2_4, Null as r4_6, Null as r6_8, Null as r8_10
	FROM parties_and_policy p
	WHERE  2 <= p.left_right  and p.left_right < 4
	Group by p.countryName)t2,
	(Select p.countryName, Null as r0_2, Null as r2_4, count(*) as r4_6, Null as r6_8, Null as r8_10
	FROM parties_and_policy p
	WHERE  4 <= p.left_right  and p.left_right < 6
	Group by p.countryName) t3,
	(Select p.countryName, Null as r0_2, Null as r2_4, Null as r4_6, count(*) as r6_8, Null as r8_10
	FROM parties_and_policy p
	WHERE  6 <= p.left_right  and p.left_right < 8
	Group by p.countryName) t4,
	(Select p.countryName, Null as r0_2, Null as r2_4, Null as r4_6, Null as r6_8, count(*) as r8_10
	FROM parties_and_policy p
	WHERE  8 <= p.left_right  and p.left_right < 10
	Group by p.countryName) t5

WHERE
	 t1.countryName = t2.countryName and 
	 t1.countryName = t2.countryName and 
	 t1.countryName = t3.countryName and
	 t1.countryName = t4.countryName and
	 t1.countryName = t5.countryName 
