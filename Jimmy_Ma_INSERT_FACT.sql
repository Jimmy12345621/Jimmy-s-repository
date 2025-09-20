
-- Constellation schema
-- 1) Tests by county
INSERT INTO fact_tests_by_county (date_id, county_id, total_tests, positive_tests)
SELECT d.date_id,
       c.county_id,
       s.total_tests,
       s.positive_tests
  FROM stg_tests AS s
  JOIN dim_date   AS d USING (report_date)
  JOIN dim_county AS c USING (county_name);

-- 2) Fatalities by county
INSERT INTO fact_fatalities_by_county (date_id, county_id, fatalities)
SELECT d.date_id,
       c.county_id,
       s.fatalities
  FROM stg_fat_county AS s
  JOIN dim_date   AS d USING (report_date)
  JOIN dim_county AS c USING (county_name);

-- 3) Fatalities by sex
INSERT INTO fact_fatalities_by_sex (date_id, sex_id, fatalities)
SELECT d.date_id,
       x.sex_id,
       s.fatality_count
  FROM stg_fat_sex    AS s
  JOIN dim_date       AS d USING (report_date)
  JOIN dim_sex        AS x USING (sex);

-- 4) Fatalities by age
INSERT INTO fact_fatalities_by_age (date_id, age_group_id, fatalities)
SELECT d.date_id,
       a.age_group_id,
       s.fatality_count
  FROM stg_fat_age     AS s
  JOIN dim_date        AS d USING (report_date)
  JOIN dim_age_group   AS a USING (age_group);


-- star schema


INSERT INTO fact_covid (date_id, county_id, total_tests, positive_tests)
SELECT d.date_id,
       c.county_id,
       s.total_tests,
       s.positive_tests
  FROM stg_tests        AS s
  JOIN dim_date         AS d ON s.report_date = d.report_date
  JOIN dim_county       AS c ON s.county_name  = c.county_name;

-- b) fatalities by county: set date_id, county_id, fatalities
INSERT INTO fact_covid (date_id, county_id, fatalities)
SELECT d.date_id,
       c.county_id,
       s.fatalities
  FROM stg_fat_county   AS s
  JOIN dim_date         AS d ON s.report_date = d.report_date
  JOIN dim_county       AS c ON s.county_name  = c.county_name;

-- c) fatalities by sex: set date_id, sex_id, fatalities
INSERT INTO fact_covid (date_id, sex_id, fatalities)
SELECT d.date_id,
       x.sex_id,
       s.fatality_count
  FROM stg_fat_sex      AS s
  JOIN dim_date         AS d ON s.report_date = d.report_date
  JOIN dim_sex          AS x ON s.sex         = x.sex;

-- d) fatalities by age: set date_id, age_group_id, fatalities
INSERT INTO fact_covid (date_id, age_group_id, fatalities)
SELECT d.date_id,
       a.age_group_id,
       s.fatality_count
  FROM stg_fat_age      AS s
  JOIN dim_date         AS d ON s.report_date = d.report_date
  JOIN dim_age_group    AS a ON s.age_group    = a.age_group;