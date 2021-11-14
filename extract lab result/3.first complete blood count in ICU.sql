-- The aim of this query is to extract first blood count during each stay(defined by stay_id)
-- The query is based on `physionet-data.mimic_derived.complete_blood_count` 
-- detail of how complete blood count were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/complete_blood_count.sql

WITH cbc_final AS
(SELECT
ie.stay_id,
le.*,
ROW_NUMBER () OVER (PARTITION BY ie.stay_id ORDER BY le.charttime) as le_seq,
FIRST_VALUE(hemoglobin) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN hemoglobin IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_hemoglobin,
FIRST_VALUE(platelet) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN platelet IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_platelet,
FIRST_VALUE(wbc) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN wbc IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_wbc
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN `physionet-data.mimic_derived.complete_blood_count` le
ON le.subject_id = ie.subject_id
),

cbc_first AS
(
SELECT
ie.subject_id,
ie.stay_id,
first_hemoglobin AS hemoglobin,
first_platelet AS platelet,
first_wbc AS wbc
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN cbc_final cf
ON ie.stay_id = cf.stay_id
AND cf.le_seq = 1
)

SELECT * FROM cbc_first;
