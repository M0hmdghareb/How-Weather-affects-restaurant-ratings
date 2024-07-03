CREATE DATABASE myproject;
USE DATABASE myproject;

-- CREATE SCHEMAS
CREATE SCHEMA STAGING;
CREATE SCHEMA ODS;
CREATE SCHEMA DATAWAREHOUSE;

USE SCHEMA STAGING;

-- CREATE JSON file format
CREATE OR REPLACE FILE FORMAT json_format
    TYPE = 'JSON'
    COMPRESSION = 'AUTO'
    STRIP_OUTER_ARRAY = TRUE;

-- CREATE CSV file format
CREATE OR REPLACE FILE FORMAT csv_format    
    TYPE = 'CSV'
    SKIP_HEADER = 1
    DATE_FORMAT = 'AUTO'
    TIME_FORMAT = 'AUTO'
    TIMESTAMP_FORMAT = 'AUTO';

-- CREATE STAGES TO UPLOAD FILES TO
CREATE OR REPLACE STAGE my_json_stage
  FILE_FORMAT = json_format;

CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = csv_format;

-- CREATE STAGING TABLES with one column of type variant
CREATE TABLE yelp_tip_tmp (tip_info VARIANT);
CREATE TABLE yelp_user_tmp (user_info VARIANT);
CREATE TABLE yelp_review_tmp (review_info VARIANT);
CREATE TABLE yelp_business_tmp (business_info VARIANT);
CREATE TABLE yelp_checkin_tmp (checkin_info VARIANT);
CREATE TABLE yelp_covid_tmp (covid_info VARIANT);
CREATE TABLE precipitation_tmp (
  date_tmp TEXT,
  precipitation_tmp TEXT,
  precipitation_normal TEXT
);
CREATE TABLE temperature_tmp (
  date TEXT,
  min TEXT,
  max TEXT,
  normal_min TEXT,
  normal_max TEXT
);

-- Upload JSON files to stage
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_academic_dataset_business.json' @my_json_stage AUTO_COMPRESS=TRUE;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_academic_dataset_tip.json' @my_json_stage AUTO_COMPRESS=TRUE;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_academic_dataset_covid_features.json' @my_json_stage AUTO_COMPRESS=TRUE;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_academic_dataset_checkin.json' @my_json_stage AUTO_COMPRESS=TRUE;

-- Upload review parts
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_review_part_01.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=6;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_review_part_02.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=6;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_review_part_03.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=6;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_review_part_04.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=6;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_review_part_05.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=6;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_review_part_06.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=6;

-- Upload user parts
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_user_part_01.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=4;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_user_part_02.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=4;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_user_part_03.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=4;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/yelp_user_part_04.json' @my_json_stage AUTO_COMPRESS=TRUE PARALLEL=4;

-- Upload CSV files to stage
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv' @my_csv_stage AUTO_COMPRESS=TRUE;
PUT 'file:///home/mohamed/Desktop/snowSQL/yelp_dataset/usw00023169-temperature-degreef.csv' @my_csv_stage AUTO_COMPRESS=TRUE;

-- Copy data from stage to staging tables
COPY INTO yelp_tip_tmp
FROM @my_json_stage/yelp_academic_dataset_tip.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_user_tmp
FROM @my_json_stage/yelp_user_part_01.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_user_tmp
FROM @my_json_stage/yelp_user_part_02.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';
COPY INTO yelp_user_tmp
FROM @my_json_stage/yelp_user_part_03.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';
COPY INTO yelp_user_tmp
FROM @my_json_stage/yelp_user_part_04.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_review_tmp
FROM @my_json_stage/yelp_review_part_01.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_review_tmp
FROM @my_json_stage/yelp_review_part_02.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';
COPY INTO yelp_review_tmp
FROM @my_json_stage/yelp_review_part_03.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';
COPY INTO yelp_review_tmp
FROM @my_json_stage/yelp_review_part_04.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';
COPY INTO yelp_review_tmp
FROM @my_json_stage/yelp_review_part_05.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';
COPY INTO yelp_review_tmp
FROM @my_json_stage/yelp_review_part_06.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_business_tmp
FROM @my_json_stage/yelp_academic_dataset_business.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_checkin_tmp
FROM @my_json_stage/yelp_academic_dataset_checkin.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO yelp_covid_tmp
FROM @my_json_stage/yelp_academic_dataset_covid_features.json.gz
FILE_FORMAT = json_format
ON_ERROR = 'CONTINUE';

COPY INTO temperature_tmp
FROM @my_csv_stage/usw00023169-temperature-degreef.csv.gz
FILE_FORMAT = csv_format
ON_ERROR = 'CONTINUE';

COPY INTO precipitation_tmp
FROM @my_csv_stage/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv.gz
FILE_FORMAT = csv_format
ON_ERROR = 'CONTINUE';
