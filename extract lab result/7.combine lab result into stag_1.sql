-- The aim of this query is to join above six query into 1(name stag_1) for future use.
-- The query is based on : 1.first GCS in ICU.sql
--                         2.first vital signs in ICU.sql
--                         3.first complete blood count in ICU.sql
--                         4.first chemistry in ICU.sql
--                         5.first blood gas in ICU.sql
--                         6.first enzyme in ICU.sql
-- All six queries can be found at https://github.com/zqr2008/mimic-database-vaildation/tree/main/extract%20lab%20result
-- (creatinine*88.4) to obtain creatinine in 'μmol/L'
-- (bun/2.80) to obtain bun in 'mmol/L',
-- (glucose/18) to obtain glucose in 'mmol/L',
-- (hemoglobin*10) to obtain hemoglobin in 'g/L'
-- (bilirubin_total*17.1) to obtain bilirubin_total in 'umol/L'
-- (heart_rate/sbp) to obtain shock index
```note that unit were converted when generating stag_1 for Chinese hospital habit```


stag_1 AS
(SELECT * FROM 
(SELECT 
art.subject_id AS subject_id,
icu.hadm_id AS hadm_id,
art.stay_id AS stay_id,
admittime,
dischtime,
dod,
los_hospital,
admission_age,	
gcs,
resp_rate,
heart_rate,
sbp,
so2,
ph,
po2,
wbc,
(creatinine*88.4) AS Creatinine,
potassium, 
sodium,
(bun/2.80) AS bun,
(glucose/18) AS Glucose,
(hemoglobin*10) AS Hemoglobin,
platelet,
(bilirubin_total*17.1) AS bilirubin_total,
(heart_rate/sbp) AS xiuke_first,

    CASE WHEN dod IS NOT NULL AND icu.dod <= DATETIME_ADD(icu.admittime, INTERVAL '7' DAY)
         THEN 0 ELSE 1
         END AS alive_7day,

    CASE WHEN dod IS NOT NULL AND icu.dod <= DATETIME_ADD(icu.admittime, INTERVAL '30' DAY)
         THEN 0 ELSE 1
         END AS alive_30day,

row_number() over (PARTITION by icu.subject_id ORDER BY admittime) AS chart_order

FROM art_first art
INNER JOIN chem_first 
ON  art.stay_id=chem_first.stay_id
INNER JOIN cbc_first 
ON  art.stay_id=cbc_first.stay_id
INNER JOIN enz_first 
ON  art.stay_id=enz_first.stay_id
INNER JOIN gcs_first
ON art.stay_id=gcs_first.stay_id
INNER JOIN vital_first vs
ON art.stay_id=vs.stay_id
INNER JOIN `physionet-data.mimic_derived.icustay_detail` icu
ON icu.stay_id=art.stay_id
)
WHERE chart_order=1 AND admission_age>=16
),
