-- --------------------------------------------------------------------------------------------------------------------------------------------
-- This query combines icu information(stored in stag_2) and ED information(stored in chief)
-- --------------------------------------------------------------------------------------------------------------------------------------------

stag_3 AS 
(
SELECT 
admission_age AS age,
chief.*,
stag_2.*,
row_number() over (PARTITION by chief.subject_id ORDER BY emergecny_intime) AS chart_order_final,

    CASE WHEN admittimee<= DATETIME_ADD(emergecny_intime, INTERVAL '1' day)
    THEN 1 ELSE 0
    END AS time_interval,
    
    CASE WHEN admittimee<= DATETIME_ADD(emergecny_intime, INTERVAL '2' hour)
    THEN 1 ELSE 0
    END AS Planed_Admit_ERD,

 FROM chief INNER JOIN stag_2 ON stag_2.subject_idd=chief.subject_id
)


