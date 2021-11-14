-- The aim of this query is to extract first GCS during each stay(defined by stay_id)
-- The query is based on `physionet-data.mimic_derived.gcs` 
-- detail of how vitalsign were extracted: https://github.com/zqr2008/mimic-code/blob/main/mimic-iv/concepts/measurement/gcs.sql

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

SELECT * FROM gcs_first;
