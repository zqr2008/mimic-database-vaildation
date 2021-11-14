-- The aim of this query is to extract first enzyme during each stay(defined by stay_id)
-- The query is based on `physionet-data.mimic_derived.enzyme` ,
-- visit:https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/enzyme.sql

enz_final AS
(SELECT
ie.stay_id,
le.*,
ROW_NUMBER () OVER (PARTITION BY ie.stay_id ORDER BY le.charttime) as le_seq,
FIRST_VALUE(bilirubin_total) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN bilirubin_total IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_bilirubin_total,
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN `physionet-data.mimic_derived.enzyme` le
ON le.subject_id = ie.subject_id
),

enz_first AS
(SELECT
ie.subject_id,
ie.stay_id,
first_bilirubin_total AS bilirubin_total
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN enz_final ef
ON ie.stay_id = ef.stay_id
AND ef.le_seq = 1
),
