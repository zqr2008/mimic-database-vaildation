-- The aim of this query is to extract first chemistry during each stay(defined by stay_id)
-- The query is based on `physionet-data.mimic_derived.chemistry` 
-- detail of how chemistry were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/chemistry.sql

WITH chem_final AS
(SELECT
ie.stay_id,
le.*,
ROW_NUMBER () OVER (PARTITION BY ie.stay_id ORDER BY le.charttime) as le_seq,
FIRST_VALUE(creatinine) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN creatinine IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_creatinine,
FIRST_VALUE(glucose) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN glucose IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_glucose,
FIRST_VALUE(sodium) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN sodium IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_sodium,
FIRST_VALUE(potassium) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN potassium IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_potassium,
FIRST_VALUE(bun) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN bun IS NULL then 0 ELSE 1 END DESC, le.charttime) as first_bun      
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN `physionet-data.mimic_derived.chemistry` le
ON le.subject_id = ie.subject_id
),

chem_first AS
(
SELECT
ie.subject_id,
ie.stay_id,
first_creatinine AS creatinine,
first_glucose AS glucose,
first_sodium AS sodium,
first_potassium AS potassium,
first_bun AS bun
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN chem_final cf
ON ie.stay_id = cf.stay_id
AND cf.le_seq = 1
)

SELECT * FROM chem_first;
