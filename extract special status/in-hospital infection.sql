-- The aim of this query is to extract in-hospital infection status, 1 for infection, 0 for no infection
-- The query is based on `physionet-data.mimic_derived.suspicion_of_infection` 
-- in-hospital infection was defined as suspected_infection_time more than 48 hour late of admission time
-- detail of how gcs were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/sepsis/suspicion_of_infection.sql




infection_1 AS
(SELECT * FROM
(SELECT 
infe.subject_id AS subject_id,
infe.stay_id AS stay_id,
suspected_infection_time,
row_number() over (PARTITION by infe.subject_id ORDER BY suspected_infection_time) AS chart_order 
FROM  `physionet-data.mimic_derived.suspicion_of_infection` infe 
) WHERE chart_order=1
),

infection_2 AS
(SELECT 
stag_1.subject_id AS subject_id,

    CASE WHEN suspected_infection_time IS NOT NULL AND suspected_infection_time>= DATETIME_ADD(stag_1.admittime, INTERVAL '2' DAY)
    THEN 1 ELSE 0
    END AS in_hospital_infection,

FROM infection_1
RIGHT JOIN stag_1 
ON stag_1.subject_id=infection_1.subject_id
),
