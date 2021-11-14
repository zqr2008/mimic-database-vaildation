### This 



WITH gcs_final AS
(SELECT
gc.*,
ROW_NUMBER () OVER (PARTITION BY gc.stay_id ORDER BY gc.charttime) as gcs_seq,
FIRST_VALUE(gcs) OVER ( PARTITION BY gc.stay_id ORDER BY 
       CASE WHEN gcs IS NULL then 0 ELSE 1 END DESC,
       gc.charttime) as first_gcs,
 FROM `physionet-data.mimic_derived.gcs` gc
),

gcs_first AS 
(
SELECT
ie.subject_id,
ie.stay_id,
first_gcs AS gcs,
FROM `physionet-data.mimic_icu.icustays` ie
LEFT JOIN gcs_final gs
ON ie.stay_id = gs.stay_id
AND gs.gcs_seq = 1
)

SELECT * FROM gcs_first 
