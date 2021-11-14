-- ------------------------------------------------------------------
-- This query(arrhythmia) extracts arrhythmia status, patients with SR (Sinus Rhythm) OR NULL record are label as normal (0), 
-- all other rhythms are consider as arrhythmia(1).
-- detail of how gcs were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/rhythm.sql
-- ------------------------------------------------------------------



arrhythmia_1 AS
( 
SELECT * FROM
(SELECT 
subject_id,
heart_rhythm,
charttime,
row_number() over (PARTITION by subject_id ORDER BY charttime) AS chart_order,
FROM `physionet-data.mimic_derived.rhythm` 
WHERE heart_rhythm NOT IN ('SR (Sinus Rhythm)')
) 
WHERE chart_order=1
),

arrhythmia_2 AS
(
SELECT 
stag_1.subject_id,

    CASE WHEN heart_rhythm IS NOT NULL AND charttime <DATETIME_ADD(stag_1.admittime, INTERVAL '6' hour)
    THEN 1 ELSE 0
    END AS arrhythmia

FROM arrhythmia_1
RIGHT JOIN stag_1 
ON stag_1.subject_id =arrhythmia_1.subject_id 
),
