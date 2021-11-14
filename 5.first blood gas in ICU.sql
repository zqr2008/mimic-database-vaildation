-- The aim of this query is to extract first blood gas during each stay(defined by stay_id)
-- The query is based on `physionet-data.mimic_derived.bg` 
-- detail of how blood gas were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/bg.sql

WITH art_final AS
(
SELECT
ie.subject_id,
ie.stay_id,
bg.*,
ROW_NUMBER () OVER (PARTITION BY ie.stay_id ORDER BY bg.charttime) as le_seq,
FIRST_VALUE(ph) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN ph IS NULL then 0 ELSE 1 END DESC, bg.charttime) as first_ph,
FIRST_VALUE(so2) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN so2 IS NULL then 0 ELSE 1 END DESC, bg.charttime) as first_so2,
FIRST_VALUE(pao2fio2ratio) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN pao2fio2ratio IS NULL then 0 ELSE 1 END DESC, bg.charttime) as first_pao2fio2ratio,
FIRST_VALUE(po2) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN po2 IS NULL then 0 ELSE 1 END DESC, bg.charttime) as first_po2,
FIRST_VALUE(pco2) OVER ( PARTITION BY ie.stay_id ORDER BY 
       CASE WHEN pco2 IS NULL then 0 ELSE 1 END DESC, bg.charttime) as first_pco2 
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN `physionet-data.mimic_derived.bg` bg
ON ie.subject_id = bg.subject_id
),

art_first AS
(SELECT
ie.subject_id,
ie.stay_id,
first_ph AS ph,
first_so2 AS so2,
first_po2 AS po2,
first_pco2 AS pco2,
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN art_final af
ON ie.stay_id = af.stay_id
AND af.le_seq = 1
)

SELECT * FROM art_first;
