USE covid_db;
-- Dates
INSERT IGNORE INTO dim_date (report_date)
  SELECT DISTINCT report_date
    FROM (
      SELECT report_date FROM stg_tests
      UNION ALL
      SELECT report_date FROM stg_fat_county
      UNION ALL
      SELECT report_date FROM stg_fat_sex
      UNION ALL
      SELECT report_date FROM stg_fat_age
    ) x;

-- Counties
INSERT IGNORE INTO dim_county (county_name)
  SELECT DISTINCT county_name
    FROM stg_tests
   UNION
  SELECT DISTINCT county_name FROM stg_fat_county;

-- Sex
INSERT IGNORE INTO dim_sex (sex)
  SELECT DISTINCT sex FROM stg_fat_sex;

-- Age groups
INSERT IGNORE INTO dim_age_group (age_group)
  SELECT DISTINCT age_group FROM stg_fat_age;
