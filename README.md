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
Copy code
SELECT first_name, last_name
FROM userdata
WHERE subscription_plan = 'Pro';
```

**Objective:** Identify users subscribed to the "Pro" plan.


