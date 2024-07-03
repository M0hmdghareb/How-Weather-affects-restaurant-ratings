-- What is the average rating for each business?
SELECT b.name, AVG(f.stars) AS average_rating
FROM DIM_BUSINESS b
JOIN FACT_REVIEW f ON b.business_id = f.business_id
GROUP BY b.business_id, b.name;


--Who are the top 10 users with the most reviews?
SELECT u.name, u.review_count
FROM DIM_USER u
ORDER BY u.review_count DESC
LIMIT 10;

--What are the 5 most recent reviews?
SELECT r.text, b.name AS business_name, u.name AS user_name, f.date
FROM FACT_REVIEW f
JOIN DIM_REVIEW r ON f.review_id = r.review_id
JOIN DIM_BUSINESS b ON f.business_id = b.business_id
JOIN DIM_USER u ON f.user_id = u.user_id
ORDER BY f.date DESC
LIMIT 5;

-- Which businesses have the highest number of 5-star reviews?
SELECT b.name, COUNT(*) AS five_star_reviews
FROM FACT_REVIEW f
JOIN DIM_BUSINESS b ON f.business_id = b.business_id
WHERE f.stars = 5
GROUP BY b.business_id, b.name
ORDER BY five_star_reviews DESC
LIMIT 10;

--Which month has the most reviews?
SELECT d.month, COUNT(*) AS review_count
FROM FACT_REVIEW f
JOIN DIM_DATE d ON f.date = d.date
GROUP BY d.month
ORDER BY review_count DESC
LIMIT 1;

--What is the distribution of review stars for each state?
SELECT b.state, f.stars, COUNT(*) AS review_count
FROM FACT_REVIEW f
JOIN DIM_BUSINESS b ON f.business_id = b.business_id
GROUP BY b.state, f.stars
ORDER BY b.state, f.stars;

--Who are the top 5 users with the highest average review rating?
SELECT u.name, AVG(f.stars) AS avg_rating
FROM FACT_REVIEW f
JOIN DIM_USER u ON f.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY avg_rating DESC
LIMIT 5;

--What is the correlation between precipitation and review ratings?
SELECT 
    CORR(t.precipitation, f.stars) AS precipitation_rating_correlation
FROM FACT_REVIEW f
JOIN DIM_TEMP t ON f.date = t.date;


--Which businesses have shown improvement in ratings over time?

WITH business_yearly_ratings AS (
    SELECT 
        b.business_id,
        b.name,
        d.year,
        AVG(f.stars) AS avg_yearly_rating
    FROM FACT_REVIEW f
    JOIN DIM_BUSINESS b ON f.business_id = b.business_id
    JOIN DIM_DATE d ON f.date = d.date
    GROUP BY b.business_id, b.name, d.year
)
SELECT 
    b1.business_id,
    b1.name,
    b1.year AS year1,
    b1.avg_yearly_rating AS rating1,
    b2.year AS year2,
    b2.avg_yearly_rating AS rating2,
    (b2.avg_yearly_rating - b1.avg_yearly_rating) AS rating_improvement
FROM business_yearly_ratings b1
JOIN business_yearly_ratings b2 ON b1.business_id = b2.business_id AND b1.year < b2.year
WHERE (b2.avg_yearly_rating - b1.avg_yearly_rating) > 0
ORDER BY rating_improvement DESC
LIMIT 10;



-- Is there a correlation between temperature and review ratings?
SELECT 
    CORR(F.STARS, (T.MAX_TEMP + T.MIN_TEMP) / 2) AS temp_rating_correlation
FROM FACT_REVIEW F
JOIN DIM_TEMP T ON T.date = F.date;



--  analyze review data alongside weather conditions
SELECT
 B.name AS business_name, F.STARS, F.USEFUL, F.FUNNY, F.COOL,T.MIN_TEMP, T.MAX_TEMP, T.NORMAL_MIN, T.NORMAL_MAX, T.PRECIPITATION, T.PRECIPITATION_NORMAL
FROM FACT_REVIEW F
JOIN DIM_BUSINESS B ON F.business_id = B.business_id
JOIN DIM_TEMP T ON T.date = F.date;




-- Is there a seasonal pattern to review ratings?
SELECT 
    EXTRACT(MONTH FROM F.date) AS month,
    AVG(F.STARS) AS avg_rating,
    AVG(T.MAX_TEMP) AS avg_max_temp,
    AVG(T.PRECIPITATION) AS avg_precipitation
FROM FACT_REVIEW F
JOIN DIM_TEMP T ON T.date = F.date
GROUP BY EXTRACT(MONTH FROM F.date)
ORDER BY month;






