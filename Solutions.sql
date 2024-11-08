-- SQL Advanced Project: Gym Check-ins and User Metadata


CREATE TABLE userdata
(
	user_id varchar(10) primary key,
	first_name varchar(10),
	last_name varchar(10),
	age INT,	
	gender varchar(10),
	birthdate date,
	sign_up_date date,
	user_location varchar(15),
	subscription_plan varchar(8)
);

CREATE TABLE gymloc
(
	gym_id varchar(8) primary key,
	locations varchar(12),
	gym_type varchar(9),
	facilities varchar(50)
);

CREATE TABLE subsplan
(
	subscription_plan varchar(8),
	price_per_month float,
	features varchar(105)
);

CREATE TABLE checkins
(
	user_id varchar(10),
	gym_id varchar(8),
	checkin_time timestamp,
	checkout_time timestamp,
	workout_type varchar(13),
	calories_burned int
);


SELECT * 
FROM checkins

SELECT *
FROM gymloc

SELECT *
FROM subsplan

SELECT *
FROM userdata



-- 13 Problems




/* 1. Write a query to find the names of users who have subscribed to the "Pro" plan. 
    Display their first_name and last_name. 
*/


SELECT 
	first_name, 
	last_name
FROM userdata
WHERE subscription_plan= 'Pro'



-- 2. How would you find the total number of recorded check-ins across all users?


SELECT 
	COUNT(user_id) AS Total_Check_ins
FROM checkins



-- 3. Write a query to list all unique workout types users have engaged in.


SELECT 	
	DISTINCT workout_type
FROM checkins



-- 4. How would you calculate the average calories burned in a workout session?


SELECT 
	AVG(calories_burned) AS average_calories_burned
FROM checkins



/* 5. How many users signed up in each user_location? 
	  List the location alongside the total user
*/


SELECT 
	COUNT(DISTINCT(user_id)) AS total_user, 	
	user_location
FROM userdata
GROUP BY user_location



/* 6. Write a query to calculate the total calories burned for each workout type at each 
	  gym location.
*/


SELECT 
	SUM(c.calories_burned) AS total_calories_burned, 	
	c.workout_type, 
	g.locations
FROM checkins c
JOIN gymloc g ON g.gym_id = c.gym_id
GROUP BY c.workout_type, g.locations
 


-- 7. Retrieve the gym location and gym_id for all gyms classified as "Premium" gyms.


SELECT 
	locations, 
	gym_id
FROM gymloc
WHERE gym_type = 'Premium'



/* 8. Find users who have checked in more than 5 times and display their user_id along with 
 	  the check-in count.
*/


SELECT 
	user_id, 
	COUNT(checkin_time) AS checkin_count
FROM checkins
GROUP BY user_id
HAVING COUNT(checkin_time) > 5



/* 9.  Write a query that joins users and gym_locations via checkin_checkout_history, 
 	   displaying each user's subscription_plan and the gym location they checked into?
*/


SELECT 
	u.user_id, 
	u.subscription_plan, 
	g.locations AS gym_location
FROM checkins c
JOIN userdata u ON c.user_id = u.user_id
JOIN gymloc g ON c.gym_id = g.gym_id;



/* 10. Calculate the average calories burned per workout type for each user using a window 
 	   function.
*/

SELECT 
	user_id,
	workout_type,
	AVG(calories_burned) OVER(PARTITION BY user_id, workout_type) AS average_calories
FROM checkins



/* 11. Use a CTE to identify users who have checked into more than one gym. Ensure each 
       user_id is unique
*/


WITH user_gym_visits AS (
    SELECT 
		user_id, 
		COUNT(DISTINCT gym_id) AS gym_count
    FROM checkins
    GROUP BY user_id
)
SELECT user_id
FROM user_gym_visits
WHERE gym_count > 1



/* 12. Find the number of distinct users who have checked into each gym and their average 
	   calories burned
*/


SELECT 
	c.gym_id,
	COUNT(DISTINCT u.user_id) AS number_of_users, 
	u.first_name, 
	u.last_name,
	AVG(calories_burned) AS average_calories_burned
FROM userdata u
JOIN checkins c ON c.user_id = u.user_id
GROUP BY c.gym_id, u.first_name, u.last_name



/* 13. Using a window function, find the latest check-in time for each user. Display user_id, 
       gym_id, and checkin_time
*/

SELECT 
	user_id, 
	gym_id, 
	checkin_time
FROM (
    SELECT 
		user_id, 
		gym_id, 
		checkin_time,
       	RANK() OVER(PARTITION BY user_id ORDER BY checkin_time DESC) AS checkin_rank
    FROM checkins
) AS ranked_checkins
WHERE checkin_rank = 1;



/* 14. Write a query that categorizes users based on their subscription plans. Use CASE WHEN 
       to label users as "High Value" if they are on the "Pro" plan, "Standard" if on the "Basic" 
       plan, and "Student" if on the "Student" plan. 
*/


SELECT user_id, 
       first_name, 
       last_name, 
       subscription_plan,
       CASE 
           WHEN subscription_plan = 'Pro' THEN 'High Value'
           WHEN subscription_plan = 'Basic' THEN 'Standard'
           WHEN subscription_plan = 'Student' THEN 'Student'
           ELSE 'Unknown'
       END AS user_category
FROM userdata;



/* 15. Write a query to calculate the total calories burned per workout in the 
    checkin_checkout_history table, and use CASE WHEN to label each workout as "Low Intensity"      if calories burned are under 300, "Medium Intensity" if between 300 and 600, 
	and "High Intensity" if over 600 
*/

SELECT workout_type, 
       SUM(calories_burned) AS total_calories,
       CASE 
           WHEN SUM(calories_burned) < 300 THEN 'Low Intensity'
           WHEN SUM(calories_burned) BETWEEN 300 AND 600 THEN 'Medium Intensity'
           ELSE 'High Intensity'
       END AS intensity_level
FROM checkins
GROUP BY workout_type;






