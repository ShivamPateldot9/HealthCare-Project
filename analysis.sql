CREATE TABLE medicalappointment (
    patient_id       BIGINT,
    appointment_id   INT PRIMARY KEY,
    gender           CHAR(1),
    scheduled_day    TIMESTAMP,
    appointment_day  TIMESTAMP,
    age              INT,
    neighbourhood    VARCHAR(60),
    scholarship      SMALLINT,
    hypertension     SMALLINT,
    diabetes         SMALLINT,
    alcoholism       SMALLINT,
    handicap         SMALLINT,
    sms_received     SMALLINT,
    no_show          VARCHAR(3),
    no_show_flag     SMALLINT
);


ALTER TABLE medicalappointment
ADD COLUMN LEAD_TIME_DAYS INT;

UPDATE medicalappointment
SET LEAD_TIME_DAYS = APPOINTMENT_DAY::DATE - SCHEDULED_DAY::DATE;

SELECT
	MIN(LEAD_TIME_DAYS),
	MAX(LEAD_TIME_DAYS)
FROM medicalappointment
	
SELECT * FROM medicalappointment
WHERE LEAD_TIME_DAYS < 0


DELETE FROM medicalappointment
WHERE LEAD_TIME_DAYS < 0

----------------- Data Exploration -------------------

-- 1. What's our overall no-show rate?

SELECT 
	no_show,
	COUNT(*) AS total_appointment,
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM medicalappointment),2) AS pct_of_total
FROM medicalappointment
GROUP BY no_show

-- Ans: 20% were no-show rate 


-- 2: Which day has more no-shows?

SELECT 
	 TO_CHAR(appointment_day::date, 'Day') as day_name,
	COUNT(*) AS total_appointment,
	SUM (CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
	ROUND (SUM ( CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) 
	AS rate_of_no_shows
FROM medicalappointment
GROUP BY day_name
ORDER BY rate_of_no_shows DESC

--Ans: Saturday had the highest (23.08%), while Friday (21.23%) and Monday (20.64%) were also relatively high.

-- 3: Does lead time matter?
-- same day
-- 1-3 days
-- within a week (4-7 days)
-- long lead (8+ days)

SELECT
	CASE 
		WHEN lead_time_days = 0 THEN 'Same Day'
		WHEN lead_time_days BETWEEN 1 AND 3 THEN 'Short (1-3 Days)'
		WHEN lead_time_days BETWEEN 4 AND 7 THEN 'Within a week'
		ELSE 'Long Lead (8+ Days)'
	END AS lead_time_bucket,
		COUNT (*) AS total_appointments,
		ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*) ,2)
		AS no_show_rate
FROM medicalappointment
GROUP BY lead_time_bucket
ORDER BY no_show_rate DESC


-- ANS: Appointments scheduled 8+ days in advance had the highest no-show rate (32.06%)



-- 4: Age groups

SELECT 
	CASE
		WHEN Age BETWEEN 0 AND 12 THEN 'Child'
		WHEN Age BETWEEN 13 AND 19 THEN 'Teen'
		WHEN Age BETWEEN 20 AND 39 THEN 'Young adult'
		WHEN Age BETWEEN 40 AND 59 THEN 'Adult'
		ELSE 'Senior'
	END AS age_group,
		COUNT(*) AS total_appointments,
		ROUND( SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) ,2) 
		AS no_show_rate
FROM medicalappointment
GROUP BY age_group
ORDER BY no_show_rate DESC


-- ANS: Teenagers had the highest no-show rate at 25.95%, and  Seniors  had lowest no-show rate at 15.31%



 
-- 5: Do SMS reminders help

SELECT 
	CASE
		WHEN sms_received = 1 THEN 'Received SMS' ELSE 'No SMS'
	END AS sms_status,
		COUNT(*) AS total_appointments,
		ROUND( SUM( CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) ,2) 
		AS no_show_rate
FROM medicalappointment
GROUP BY sms_status

--ANS: Patients who received an SMS reminder had a higher no-show rate (27.57%),
--	   compared with patients who did not receive an SMS (16.70%).



-- 6: Which neighborhoods have the highest risk? 

SELECT 
	neighbourhood,
	COUNT(*) AS total_appointments,
	ROUND( SUM( CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
	AS no_show_rate,
	RANK() OVER( ORDER BY ROUND ( SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) ,2) DESC )
	AS risk_rank
FROM medicalappointment
GROUP BY neighbourhood
HAVING COUNT(*) >= 100
ORDER BY no_show_rate DESC
LIMIT 15

-- ANS: Santos Dumont had the highest no-show rate at 28.92%, 
--      followed by Santa Cecília (27.46%) and Santa Clara (26.48%)









