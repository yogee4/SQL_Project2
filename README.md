# SQL_Project: Gym Managment System Data Analysis

![](https://github.com/yogee4/SQL_Project2/blob/main/Custom_logo.png)

## Project Overview

This SQL project uses gym membership and user check-in data to explore user engagement, gym usage patterns, and subscription plan data. The queries range from basic to advanced levels, covering concepts such as joins, grouping, aggregate functions, window functions, CTEs, and CASE WHEN logic. The objective is to practice SQL skills and analyze gym usage behavior.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [GYM Datasets](https://www.kaggle.com/datasets/mexwell/gym-check-ins-and-user-metadata)

  ## Schema

```sql
CREATE TABLE userdata (
    user_id varchar(10) PRIMARY KEY,
    first_name varchar(10),
    last_name varchar(10),
    age INT,
    gender varchar(10),
    birthdate DATE,
    sign_up_date DATE,
    user_location varchar(15),
    subscription_plan varchar(8)
);

CREATE TABLE gymloc (
    gym_id varchar(8) PRIMARY KEY,
    locations varchar(12),
    gym_type varchar(9),
    facilities varchar(50)
);

CREATE TABLE subsplan (
    subscription_plan varchar(8),
    price_per_month FLOAT,
    features varchar(105)
);

CREATE TABLE checkins (
    user_id varchar(10),
    gym_id varchar(8),
    checkin_time TIMESTAMP,
    checkout_time TIMESTAMP,
    workout_type varchar(13),
    calories_burned INT
);
```

## Data Analysis Problems and Solutions

### 1. Find the names of users who have subscribed to the "Pro" plan.

```sql
SELECT first_name, last_name
FROM userdata
WHERE subscription_plan = 'Pro';
```

**Objective:** Identify users subscribed to the "Pro" plan.

### 2. Find the total number of recorded check-ins across all users.

```sql
Copy code
SELECT COUNT(user_id) AS Total_Check_ins
FROM checking;
```

**Objective:** Count the total number of check-ins.

### 3. List all unique workout types users have engaged in.

```sql
SELECT DISTINCT workout_type
FROM checking;
```

**Objective:** Display unique workout types.

### 4. Calculate the average calories burned in a workout session.

```sql
SELECT AVG(calories_burned) AS average_calories_burned
FROM checking;
```

**Objective:** Calculate average calories burned per workout.

### 5. How many users signed up in each user_location?

```sql
SELECT user_location, COUNT(DISTINCT user_id) AS total_user
FROM userdata
GROUP BY user_location;
```

**Objective:** Count users by location.

### 6. Calculate the total calories burned for each workout type at each gym location.

```sql
SELECT SUM(c.calories_burned) AS total_calories_burned, c.workout_type, g.locations
FROM checkins c
JOIN gymloc g ON g.gym_id = c.gym_id
GROUP BY c.workout_type, g.locations;
```

**Objective:** Sum calories burned per workout type and location.

### 7. Retrieve the gym location and gym_id for "Premium" gyms.

```sql
SELECT locations, gym_id
FROM gymloc
WHERE gym_type = 'Premium';
```

**Objective:** Find premium gyms by location and ID.

### 8. Find users who have checked in more than 5 times.

```sql
SELECT user_id, COUNT(checkin_time) AS checkin_count
FROM checkins
GROUP BY user_id
HAVING COUNT(checkin_time) > 5;
```

**Objective:** Show users with high check-in counts.

### 9. Display each user's subscription_plan and the gym location they checked into.

```sql
SELECT u.user_id, u.subscription_plan, g.locations AS gym_location
FROM checkins c
JOIN userdata u ON c.user_id = u.user_id
JOIN gymloc g ON c.gym_id = g.gym_id;
```

**Objective:** Join users and gym locations to show subscription plans and check-in locations.

### 10. Calculate the average calories burned per workout type for each user.

```sql
SELECT user_id, workout_type, AVG(calories_burned) OVER(PARTITION BY user_id, workout_type) AS average_calories
FROM checkins;
```

**Objective:** Use window function to get average calories burned.

### 11. Identify users who checked into more than one gym.

```sql
WITH user_gym_visits AS (
    SELECT user_id, COUNT(DISTINCT gym_id) AS gym_count
    FROM checkins
    GROUP BY user_id
)
SELECT user_id
FROM user_gym_visits
WHERE gym_count > 1;
```

**Objective:** Use CTE to find multi-gym users.

### 12. Find distinct users per gym and average calories burned.

```sql
SELECT c.gym_id, COUNT(DISTINCT u.user_id) AS number_of_users, AVG(calories_burned) AS average_calories_burned
FROM userdata u
JOIN checkins c ON c.user_id = u.user_id
GROUP BY c.gym_id;
```

**Objective:** Aggregate user count and average calories per gym.

### 13. Find the latest check-in time for each user.

```sql
SELECT user_id, gym_id, checkin_time
FROM (
    SELECT user_id, gym_id, checkin_time, RANK() OVER(PARTITION BY user_id ORDER BY checkin_time DESC) AS checkin_rank
    FROM checkins
) AS ranked_checkins
WHERE checkin_rank = 1;
```

**Objective:** Use window function to get the latest check-in per user.

### 14. Categorize users based on their subscription plans.

```sql
SELECT user_id, first_name, last_name, subscription_plan,
       CASE 
           WHEN subscription_plan = 'Pro' THEN 'High Value'
           WHEN subscription_plan = 'Basic' THEN 'Standard'
           WHEN subscription_plan = 'Student' THEN 'Student'
           ELSE 'Unknown'
       END AS user_category
FROM userdata;
```

**Objective:** Use CASE WHEN to label users by plan.

### 15. Categorize workouts by intensity based on calories burned.

```sql
SELECT workout_type, SUM(calories_burned) AS total_calories,
       CASE 
           WHEN SUM(calories_burned) < 300 THEN 'Low Intensity'
           WHEN SUM(calories_burned) BETWEEN 300 AND 600 THEN 'Medium Intensity'
           ELSE 'High Intensity'
       END AS intensity_level
FROM checkins
GROUP BY workout_type;
```

**Objective:** Use CASE WHEN to classify workouts by intensity.

## Findings:

- Subscription Insights: "Pro" plan users are highly engaged, indicating value in premium subscriptions.

- User Activity: A subset of users shows high check-in frequency, and average calories burned provide insight into workout intensity.

- Location-Based Patterns: Certain locations have high user density and calories burned, suggesting these are preferred for intense workouts.

- Multi-Gym Check-Ins: Users checking into multiple gyms indicate a demand for flexible, multi-location memberships.

- Workout Intensity: Classifying workouts by intensity helps align offerings with user preferences.

## Conclusion: 

Understanding user behavior by subscription type, activity, and location enables targeted offerings, optimized operations, and improved user satisfaction, ultimately driving membership growth and retention.

Thank you for your support, and I look forward to connecting with you!
