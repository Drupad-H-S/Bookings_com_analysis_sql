--total number of bookings made at each hotel
SELECT
    hotel,
    COUNT(*) AS total_bookings
FROM
    bookings
GROUP BY
    hotel
ORDER BY
    total_bookings DESC;


--How many bookings were canceled at each hotel
SELECT
    hotel,
    COUNT(*) AS canceled_bookings
FROM
    bookings
WHERE
    is_canceled = 1
GROUP BY
    hotel
ORDER BY
    canceled_bookings DESC;


--the most common meal type booked by customers
SELECT
    meal,
    COUNT(*) AS count
FROM
    bookings
GROUP BY
    meal
ORDER BY
    count DESC
LIMIT 1;


--number of bookings according to countries?
SELECT
    country,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    country
ORDER BY
    number_of_bookings DESC;


--distribution of market segments among bookings
SELECT
    market_segment,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    market_segment
ORDER BY
    number_of_bookings DESC;

-- How many bookings were made with a deposit and without a deposit?
SELECT
    deposit_type,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    deposit_type
ORDER BY
    number_of_bookings DESC;



--What is the average price per night for each hotel?
SELECT
    hotel,
    AVG(price / number_of_days_stays) AS average_price_per_night
FROM
    bookings
GROUP BY
    hotel
ORDER BY
    average_price_per_night DESC;


--How many bookings included car parking spaces?

SELECT
    COUNT(*) AS bookings_with_parking
FROM
    bookings
WHERE
    required_car_parking_spaces > 0;

--What is the average length of stay for each hotel?
SELECT
    hotel,
    AVG(number_of_days_stays) AS average_length_of_stay
FROM
    bookings
GROUP BY
    hotel
ORDER BY
    average_length_of_stay DESC;


--How many bookings were made for weekend nights?
SELECT
    COUNT(*) AS bookings_with_weekend_nights
FROM
    bookings
WHERE
    stays_in_weekend_nights > 0;


--What is the average number of days stayed for each booking?
SELECT
    booking_id,
    AVG(number_of_days_stays) AS average_days_stayed
FROM
    bookings
GROUP BY
    booking_id;


--What is the percentage of bookings that were canceled?
WITH TotalBookings AS (
    SELECT COUNT(*) AS total_bookings
    FROM bookings
),
CanceledBookings AS (
    SELECT COUNT(*) AS canceled_bookings
    FROM bookings
    WHERE is_canceled = 1
)
SELECT
    (canceled_bookings * 100.0 / total_bookings) AS percentage_canceled
FROM
    TotalBookings,
    CanceledBookings;

--What is the most common reservation status for bookings?
SELECT
    reservation_status,
    COUNT(*) AS count
FROM
    bookings
GROUP BY
    reservation_status
ORDER BY
    count DESC;


--What are the top 5 agents by the number of bookings they handled?
SELECT
    agent,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    agent
ORDER BY
    number_of_bookings DESC
	LIMIT 5;


--How does the booking distribution vary by month?
SELECT
    EXTRACT(YEAR FROM booking_date) AS year,
    EXTRACT(MONTH FROM booking_date) AS month,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    year,
    month
ORDER BY
    year,
    month;

--What is the average price per night for each meal type?
SELECT
    meal,
    AVG(price / number_of_days_stays) AS average_price_per_night
FROM
    bookings
GROUP BY
    meal
ORDER BY
    average_price_per_night DESC;

--How does the booking trend change over the years?
SELECT
    EXTRACT(YEAR FROM booking_date) AS year,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    year
ORDER BY
    year;

--What are the top 10 customers by the number of bookings they made?
SELECT
    name,
    email,
    COUNT(*) AS number_of_bookings
FROM
    bookings
GROUP BY
    name, email
ORDER BY
    number_of_bookings DESC
LIMIT 10;


--Classify the bookings as 'High Price' if the price is greater than the average price, otherwise 'Low Price' price_segment count booking 
WITH CTE
AS
(    
    SELECT 
            booking_id,
            booking_date,
            price,
            number_of_days_stays,
            CASE           
                WHEN price > (SELECT AVG(price) FROM bookings) THEN 'High Price'
                ELSE 'Low Price'
            END as price_segment
    FROM bookings
)
SELECT 
    price_segment,
    count(1)
from  CTE
GROUP BY   price_segment;


--Do bookings made through agents exhibit different cancellation rates or booking durations
compared to direct bookings
WITH BookingTypes AS (
    SELECT
        CASE
            WHEN agent IS NOT NULL THEN 'Agent'
            ELSE 'Direct'
        END AS booking_method,
        COUNT(*) AS total_bookings,
        SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_bookings
    FROM
        bookings
    GROUP BY
        booking_method
)
SELECT
    booking_method,
    (canceled_bookings * 100.0 / total_bookings) AS cancellation_rate
FROM
    BookingTypes;

