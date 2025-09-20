USE covid_db;

-- dimensions
-- original source key 

-- pre-computing 
CREATE TABLE IF NOT EXISTS dim_date (
  date_id      INT AUTO_INCREMENT PRIMARY KEY,
  report_date  DATE             UNIQUE
);
CREATE TABLE IF NOT EXISTS dim_county (
  county_id    INT AUTO_INCREMENT PRIMARY KEY,
  county_name  VARCHAR(100)     UNIQUE
);
CREATE TABLE IF NOT EXISTS dim_sex (
  sex_id       INT AUTO_INCREMENT PRIMARY KEY,
  sex          VARCHAR(20)      UNIQUE
);
CREATE TABLE IF NOT EXISTS dim_age_group (
  age_group_id INT AUTO_INCREMENT PRIMARY KEY,
  age_group    VARCHAR(50)      UNIQUE
);

-- constellation facts
CREATE TABLE IF NOT EXISTS fact_tests_by_county (
  fact_id        INT AUTO_INCREMENT PRIMARY KEY,
  date_id        INT,
  county_id      INT,
  total_tests    INT,
  positive_tests INT,
  FOREIGN KEY(date_id)   REFERENCES dim_date(date_id),
  FOREIGN KEY(county_id) REFERENCES dim_county(county_id)
);

CREATE TABLE IF NOT EXISTS fact_fatalities_by_county (
  fact_id   INT AUTO_INCREMENT PRIMARY KEY,
  date_id   INT,
  county_id INT,
  fatalities INT,
  FOREIGN KEY(date_id)   REFERENCES dim_date(date_id),
  FOREIGN KEY(county_id) REFERENCES dim_county(county_id)
);

CREATE TABLE IF NOT EXISTS fact_fatalities_by_sex (
  fact_id   INT AUTO_INCREMENT PRIMARY KEY,
  date_id   INT,
  sex_id    INT,
  fatalities INT,
  FOREIGN KEY(date_id) REFERENCES dim_date(date_id),
  FOREIGN KEY(sex_id)    REFERENCES dim_sex(sex_id)
);

CREATE TABLE IF NOT EXISTS fact_fatalities_by_age (
  fact_id      INT AUTO_INCREMENT PRIMARY KEY,
  date_id      INT,
  age_group_id INT,
  fatalities   INT,
  FOREIGN KEY(date_id)      REFERENCES dim_date(date_id),
  FOREIGN KEY(age_group_id) REFERENCES dim_age_group(age_group_id)
);


CREATE TABLE IF NOT EXISTS fact_covid (
  fact_id         INT AUTO_INCREMENT PRIMARY KEY,
  date_id         INT NOT NULL,
  county_id       INT,       -- NULLable for statewide facts
  sex_id          INT,       -- NULLable for county facts
  age_group_id    INT,       -- NULLable for county/sex facts
  total_tests     INT,
  positive_tests  INT,
  fatalities      INT,
  FOREIGN KEY (date_id)      REFERENCES dim_date(date_id),
  FOREIGN KEY (county_id)    REFERENCES dim_county(county_id),
  FOREIGN KEY (sex_id)       REFERENCES dim_sex(sex_id),
  FOREIGN KEY (age_group_id) REFERENCES dim_age_group(age_group_id)
);