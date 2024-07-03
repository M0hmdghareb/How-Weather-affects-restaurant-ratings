USE DATABASE MYPROJECT;
USE SCHEMA DATAWAREHOUSE;

-- CREATE dimensional tables

-- DIM BUSINESS
CREATE TABLE DIM_BUSINESS (
    business_id VARCHAR(30) PRIMARY KEY NOT NULL,
    name VARCHAR(255),
    address VARCHAR(120),
    city VARCHAR(55),
    state VARCHAR(3),
    postal_code VARCHAR(8),
    stars DECIMAL, 
    review_count INT, 
    is_open INT
);

-- DIM USER 
CREATE TABLE DIM_USER (
    user_id VARCHAR(30) PRIMARY KEY NOT NULL,
    name VARCHAR(255),
    review_count INT,
    average_stars DECIMAL,
    useful INT,
    funny INT,
    cool INT,
    yelping_since TIMESTAMP
);

-- DIM REVIEW
CREATE TABLE DIM_REVIEW (
    review_id VARCHAR(30) PRIMARY KEY NOT NULL,
    text VARCHAR(10000)
);

-- DIM DATE
CREATE TABLE DIM_DATE (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

-- DIM TEMP
CREATE TABLE DIM_TEMP (
    date DATE PRIMARY KEY,
    min_temp INT,
    max_temp INT,
    normal_min FLOAT,
    normal_max FLOAT,
    precipitation FLOAT,
    precipitation_normal FLOAT
);

-- FACT REVIEW table
CREATE TABLE FACT_REVIEW (
    review_id VARCHAR(30) PRIMARY KEY NOT NULL,
    business_id VARCHAR(30) REFERENCES DIM_BUSINESS(business_id),
    user_id VARCHAR(30) REFERENCES DIM_USER(user_id),
    date DATE REFERENCES DIM_DATE(date),
    stars INT,
    useful INT,
    funny INT,
    cool INT
);

-- Insert data into tables

INSERT INTO DIM_BUSINESS(business_id, name, address, city, state, postal_code, stars, review_count, is_open)
SELECT business_id, name, address, city, state, postal_code, stars, review_count, is_open
FROM ODS.YELP_BUSINESS;

INSERT INTO DIM_USER(user_id, name, review_count, average_stars, useful, funny, cool, yelping_since)
SELECT user_id, name, review_count, average_stars, useful, funny, cool, yelping_since
FROM ODS.YELP_USER;

INSERT INTO DIM_REVIEW(review_id, text)
SELECT review_id, text  
FROM ODS.YELP_REVIEW;

INSERT INTO DIM_DATE(date, year, month, day)
SELECT date, EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month, EXTRACT(DAY FROM date) AS day
FROM ODS.temperature;

-- DIM TEMP
INSERT INTO DIM_TEMP(date, min_temp, max_temp, normal_min, normal_max, precipitation, precipitation_normal)
SELECT t.date, t.min, t.max, t.normal_min, t.normal_max, p.precipitation, p.precipitation_normal
FROM ODS.temperature t
JOIN ODS.precipitation p ON t.date = p.date;

-- FACT REVIEW
INSERT INTO FACT_REVIEW(review_id, business_id, user_id, date, stars, useful, funny, cool)
SELECT review_id, business_id, user_id, date, stars, useful, funny, cool
FROM ODS.YELP_REVIEW;
