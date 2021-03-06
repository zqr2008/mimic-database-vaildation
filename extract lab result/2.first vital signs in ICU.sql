-- The aim of this query is to extract first vital signs during each stay(defined by stay_id)
-- The query is based on `physionet-data.mimic_derived.vitalsign` 
-- detail of how vitalsigns were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/vitalsign.sql  

WITH vital_final AS
(SELECT
vital.*, 
ROW_NUMBER () OVER (PARTITION BY vital.stay_id ORDER BY vital.charttime) as vf_seq,
FIRST_VALUE(resp_rate) OVER ( PARTITION BY vital.stay_id ORDER BY 
       CASE WHEN resp_rate IS NULL then 0 ELSE 1 END DESC,
      vital.charttime) as first_resp_rate,
FIRST_VALUE(heart_rate) OVER ( PARTITION BY vital.stay_id ORDER BY 
       CASE WHEN heart_rate IS NULL then 0 ELSE 1 END DESC,
      vital.charttime) as first_heart_rate,
FIRST_VALUE(sbp) OVER ( PARTITION BY vital.stay_id ORDER BY 
       CASE WHEN sbp IS NULL then 0 ELSE 1 END DESC,
      vital.charttime) as first_sbp,
FIRST_VALUE(spo2) OVER ( PARTITION BY vital.stay_id ORDER BY 
       CASE WHEN spo2 IS NULL then 0 ELSE 1 END DESC,
      vital.charttime) as first_spo2,

FROM `physionet-data.mimic_derived.vitalsign` vital
),

vital_first AS
(
SELECT
ie.subject_id,
ie.stay_id,
first_heart_rate AS heart_rate,
first_sbp AS sbp,
first_resp_rate AS resp_rate,
first_spo2 AS spo2,
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN vital_final vf
ON ie.stay_id = vf.stay_id
AND vf.vf_seq = 1
)

SELECT * FROM vital_first; 
