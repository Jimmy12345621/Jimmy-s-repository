USE covid_db;

CREATE TABLE IF NOT EXISTS stg_tests (
  report_date             DATE,
  county_name             VARCHAR(100),
  positive_tests          INT,
  cumulative_number_of_positives INT,
  total_tests             INT,
  cumulative_number_of_tests_performed INT,
  test_pct_positive       DECIMAL(5,2),
  geography               VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS stg_fat_county (
  report_date DATE,
  county_name VARCHAR(100),
  place_of_fatality VARCHAR(100),
  fatalities   INT
);

CREATE TABLE IF NOT EXISTS stg_fat_sex (
  report_date   DATE,
  sex           VARCHAR(20),
  fatality_count INT,
  percent       DECIMAL(5,2)
);

CREATE TABLE IF NOT EXISTS stg_fat_age (
  report_date    DATE,
  age_group      VARCHAR(50),
  fatality_count INT,
  percent        DECIMAL(5,2)
);

-- mimic original databases
-- staging area
-- not too much processing 
LOAD DATA INFILE
  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/New_York_State_Statewide_COVID-19_Testing__Archived__20250408.csv'
INTO TABLE stg_tests
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@report_date,
 county_name,
 positive_tests,
 cumulative_number_of_positives,
 total_tests,
 cumulative_number_of_tests_performed,
 @test_pct_positive,
 geography)
SET
  report_date       = STR_TO_DATE(@report_date,      '%m/%d/%Y'),
  test_pct_positive = REPLACE(@test_pct_positive, '%', '');
-- Parse the string date into a real DATE
-- Strip off the “%”

-- Fatalities by county
LOAD DATA INFILE
  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/New_York_State_Statewide_COVID-19_Fatalities_by_County_20250408.csv'
INTO TABLE stg_fat_county
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@report_date, county_name, place_of_fatality, fatalities)
SET
  report_date = STR_TO_DATE(@report_date, '%m/%d/%Y');

-- Fatalities by sex
LOAD DATA INFILE
  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/New_York_State_Statewide_COVID-19_Fatalities_by_Sex__Archived__20250408.csv'
INTO TABLE stg_fat_sex
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@report_date, sex, fatality_count, @percent)
SET
  report_date = STR_TO_DATE(@report_date, '%m/%d/%Y'),
  percent     = REPLACE(@percent, '%', '');

-- Fatalities by age group
LOAD DATA INFILE
  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/New_York_State_Statewide_COVID-19_Fatalities_by_Age_Group__Archived__20250408.csv'
INTO TABLE stg_fat_age
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@report_date, age_group, fatality_count, @percent)
SET
  report_date = STR_TO_DATE(@report_date, '%m/%d/%Y'),
  percent     = REPLACE(@percent, '%', '');


-- 2023-08-30,Albany,17,80708,103,1473117,10.99%,COUNTY
-- 2023-08-30,Albany,17,80708,103,1473117,10.99%,COUNTY
