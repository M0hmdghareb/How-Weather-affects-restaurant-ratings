use DATABASE MYPROJECT ; 
USE SCHEMA ODS ;

-- Create YELP_COVID table
CREATE TABLE YELP_COVID (
    business_id VARCHAR(30),
    highlights VARIANT,
    delivery_or_takeout VARIANT,
    grubhub_enabled VARIANT,
    call_to_action_enabled VARIANT,
    request_a_quote_enabled VARIANT,
    covid_banner VARIANT,
    temporary_closed_until VARIANT,
    virtual_services_offered VARIANT
);

-- Create YELP_BUSINESS table
CREATE TABLE YELP_BUSINESS (
  business_id VARCHAR(30), 
  name VARCHAR(70), 
  address VARCHAR(120), 
  city VARCHAR(55), 
  state VARCHAR(3), 
  postal_code  VARCHAR(8), 
  latitude DECIMAL, 
  longitude DECIMAL, 
  stars DECIMAL, 
  review_count INTEGER, 
  is_open INTEGER, 
  attributes VARIANT, 
  categories varchar(800), 
  hours VARIANT
);

-- Create YELP_TIP table
CREATE TABLE YELP_TIP (
  user_id VARCHAR(255), 
  business_id VARCHAR(255), 
  text VARCHAR(4000), 
  date TIMESTAMP, 
  compliment_count INTEGER
);

-- Create YELP_USER table
CREATE TABLE YELP_USER (
    user_id VARCHAR(30),
    name VARCHAR(255),
    review_count INTEGER,
    yelping_since TIMESTAMP,
    useful INTEGER,
    funny INTEGER,
    cool INTEGER,
    elite VARIANT,
    friends VARIANT,
    fans INTEGER,
    average_stars DECIMAL,
    compliment_hot INTEGER,
    compliment_more INTEGER,
    compliment_profile INTEGER,
    compliment_cute INTEGER,
    compliment_list INTEGER,
    compliment_note INTEGER,
    compliment_plain INTEGER,
    compliment_cool INTEGER,
    compliment_funny INTEGER,
    compliment_writer INTEGER,
    compliment_photos INTEGER
);

-- Create YELP_REVIEW table

CREATE TABLE YELP_REVIEW (
    review_id VARCHAR(30),
    user_id VARCHAR(30),
    business_id VARCHAR(30), 
    stars INTEGER, 
    useful INTEGER, 
    funny INTEGER,
    cool INTEGER, 
    text  VARCHAR(10000), 
    date TIMESTAMP
);

-- Create YELP_CHECKIN table
CREATE TABLE YELP_CHECKIN (
    business_id VARCHAR(30),
    date VARCHAR
);

-- Create temperature table
CREATE TABLE temperature (
    date DATE,
    min INT,
    max INT,
    normal_min FLOAT,
    normal_max FLOAT
);

-- Create precipitation table
CREATE TABLE precipitation (
    date DATE,
    precipitation FLOAT,
    precipitation_normal FLOAT
);

--                                       INSERT DATA INTO TABLES

-- insert YELP_TIP
INSERT INTO YELP_TIP(
  user_id, business_id, text, date, compliment_count
) 
SELECT 
  parse_json($1): user_id, 
  parse_json($1): business_id, 
  parse_json($1): text, 
  parse_json($1): date, 
  parse_json($1): compliment_count 
FROM MYPROJECT.STAGING.YELP_TIP_TMP;

  -- insert YELP_BUSINESS
INSERT INTO YELP_BUSINESS(
  business_id, name, address, city, state,  postal_code, latitude, longitude, 
  stars, review_count, is_open, attributes,  categories, hours
) 
SELECT 
  parse_json($1): business_id, 
  parse_json($1): name, 
  parse_json($1): address, 
  parse_json($1): city, 
  parse_json($1): state, 
  parse_json($1): postal_code, 
  parse_json($1): latitude, 
  parse_json($1): longitude, 
  parse_json($1): stars, 
  parse_json($1): review_count, 
  parse_json($1): is_open, 
  parse_json($1): attributes, 
  parse_json($1): categories, 
  parse_json($1): hours 

FROM MYPROJECT.STAGING.YELP_BUSINESS_TMP;

-- insert YELP_REVIEW
INSERT INTO YELP_REVIEW(
  review_id, user_id, business_id, stars, useful, funny, cool, text, date
) 
SELECT 
  parse_json($1): review_id,
  parse_json($1): user_id,
  parse_json($1): business_id,
  parse_json($1): stars,
  parse_json($1): useful,
  parse_json($1): funny,
  parse_json($1): cool,
  parse_json($1): text,
  parse_json($1): date

FROM MYPROJECT.STAGING.YELP_REVIEW_TMP;

-- insert YELP_USER
INSERT INTO YELP_USER (
    user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends, fans, average_stars,
    compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note,
    compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos
)
SELECT
    parse_json($1): user_id,
    parse_json($1): name,
    parse_json($1): review_count,
    parse_json($1): yelping_since,
    parse_json($1): useful,
    parse_json($1): funny,
    parse_json($1): cool,
    parse_json($1): elite,
    parse_json($1): friends,
    parse_json($1): fans,
    parse_json($1): average_stars,
    parse_json($1): compliment_hot,
    parse_json($1): compliment_more,
    parse_json($1): compliment_profile,
    parse_json($1): compliment_cute,
    parse_json($1): compliment_list,
    parse_json($1): compliment_note,
    parse_json($1): compliment_plain,
    parse_json($1): compliment_cool,
    parse_json($1): compliment_funny,
    parse_json($1): compliment_writer,
    parse_json($1): compliment_photos
FROM  MYPROJECT.STAGING.YELP_USER_TMP;  

-- insert YELP_CHECKIN
INSERT INTO YELP_CHECKIN (
    business_id, date
)
SELECT
    parse_json($1): business_id,
    CAST(SPLIT(parse_json($1): date, ',') AS VARCHAR) as date
FROM  MYPROJECT.STAGING.YELP_CHECKIN_TMP;


-- insert YELP_COVID
INSERT INTO YELP_COVID (
    business_id, highlights, delivery_or_takeout, grubhub_enabled, call_to_action_enabled,
    request_a_quote_enabled, covid_banner, temporary_closed_until, virtual_services_offered
)
SELECT
    parse_json($1): business_id,
    parse_json($1): highlights,
    parse_json($1): "delivery or takeout",
    parse_json($1): "Grubhub enabled",
    parse_json($1): "Call To Action enabled",
    parse_json($1): "Request a Quote Enabled",
    parse_json($1): "Covid Banner",
    parse_json($1): "Temporary Closed Until",
    parse_json($1): "Virtual Services Offered"
FROM MYPROJECT.STAGING.YELP_COVID_TMP;

-- insert temperature
INSERT INTO temperature (date, min, max, normal_min, normal_max)
SELECT
    TO_DATE(date, 'YYYYMMDD'),
    CAST(min AS INT),
    CAST(max AS INT),
    CAST(normal_min AS FLOAT),
    CAST(normal_max AS FLOAT)
FROM MYPROJECT.STAGING.temperature_tmp;

-- insert precipitation
INSERT INTO precipitation (date, precipitation, precipitation_normal)
SELECT
    TO_DATE(date_tmp, 'YYYYMMDD'),
    CASE
        WHEN precipitation_tmp = 'T' THEN 0.0  -- Replace 'T' with 0.0 or any other value
        ELSE CAST(precipitation_tmp AS FLOAT)
    END,
    CAST(precipitation_normal AS FLOAT)
FROM MYPROJECT.STAGING.precipitation_tmp;


