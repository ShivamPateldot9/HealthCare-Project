# Healthcare Appointment No-Show Analysis

I did this project to understand why patients miss their medical appointments. I cleaned the data in Python, analysed it with SQL in PostgreSQL, and made a dashboard in Tableau.

## About the data
The dataset is "Medical Appointment No Shows" from Kaggle. It has around 110,000 appointments from Brazil (April to June 2016) with details like age, neighbourhood, scholarship, whether an SMS was sent, and whether the patient showed up.

One thing that confused me at first: in the `no_show` column, "Yes" means the patient did NOT come.

## What I did

**1. Cleaning in Python**
- Changed column names to lowercase with underscores and fixed two spelling mistakes (`hipertension` and `handcap`)
- Converted the date columns to datetime
- Made a `no_show_flag` column (1 = did not come, 0 = came) so I could take averages easily
- Removed one row where age was -1
- Saved the cleaned file as `healthcare_appointments_cleaned.csv`

**2. Analysis in PostgreSQL**
I loaded the cleaned file into a table and wrote queries for 6 questions. All queries are in `sql/analysis_queries.sql`.

**3. Dashboard in Tableau**
Made a dashboard from the cleaned CSV with 3 KPIs (total appointments, no-show rate, average lead time) and 3 charts (by day of week, by lead time, and top 15 neighbourhoods).

![Healthcare Appointment No-Show Dashboard](dashboard/dashboard_Dashboard.png)

## Key Findings

- About 20% of appointments were no-shows, so roughly 1 in 5 patients did not come.
- Lead time showed a strong association with no-shows. Same day appointments had around 4.6% no-shows, but appointments booked 8 or more       days earlier had around 32%.
- Teenagers missed the most (about 26%) and seniors the least (about 15%).
- Santos Dumont had the highest no-show rate (28.9%) among neighbourhoods with at least 100 appointments.
- Days of the week did not differ much. Saturday was highest, but it had only 39 appointments, so I did not rely on it.
- Patients who got an SMS had a higher no-show rate (27.6% vs 16.7%). I don't think SMS causes this. SMS is mostly sent for appointments booked far ahead, and those already have more no-shows. I did not test this, so it is only my explanation.

## Recommendations

- Send reminders for appointments that are booked more than a week ahead.
- Pay more attention to teenagers.
- Look at why some neighbourhoods have higher no-shows (distance, transport, etc.).

## Limitations

- Data covers about six weeks only, so April and June are incomplete.
- This shows patterns, not causes.
- I did not build a prediction model.

  
## Files
- `data/` raw and cleaned CSV
- `notebooks/01_data_cleaning.ipynb` Python cleaning
- `sql/analysis_queries.sql` SQL queries with my answers
- `dashboard/` Tableau workbook and screenshot
