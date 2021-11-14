-- --------------------------------------------------------------------------------------------------------------------------------------------
-- This query extracts information in Emergency Deparment,mainly included chief complaint and vitial signs;
-- Those with certain cheif complaint are coded as 1, without are coded as 0;
-- --------------------------------------------------------------------------------------------------------------------------------------------



cheif AS (
SELECT 
cheif.subject_id AS subject_id,
cheif.stay_id AS stay_id,
intime AS emergecny_intime,
chiefcomplaint,
heartrate,
resprate,
o2sat,
sbp as bloodpressure,	
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%chest pain%') THEN 1 
     ELSE 0 END AS chest_pain,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER  ('%abdominal pain%') OR
          UPPER (chiefcomplaint) LIKE UPPER('%abd pain%') THEN 1 
     ELSE 0 END AS abdominal_pain,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%chest tightness%') THEN 1
     ELSE 0 END AS chest_tightness,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%dyspnea%') OR
          UPPER (chiefcomplaint) LIKE UPPER('%Difficulty breath%') OR 
		  UPPER (chiefcomplaint) LIKE UPPER ('%SOB%') OR
		  UPPER (chiefcomplaint) LIKE UPPER ('SHORTNESS OF BREATH') OR
		  UPPER (chiefcomplaint) LIKE UPPER ('Respiratory distress') THEN 1 
     ELSE 0 END AS dyspnea,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%fever%') THEN 1 
     ELSE 0 END AS fever,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%syncope%') THEN 1 
     ELSE 0 END AS syncope,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%fatigue%') OR 
                (chiefcomplaint) LIKE UPPER ('%weakness%') THEN 1 
     ELSE 0 END AS fatigue,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%palpitation%') THEN 1 
     ELSE 0 END AS palpitation,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%Hematemesis%') OR
          UPPER (chiefcomplaint) LIKE UPPER('%vomiting blood%') THEN 1 
     ELSE 0 END AS Hematemesis,	 
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%bloody stool%') OR 
          UPPER (chiefcomplaint) LIKE UPPER('%melena%') THEN 1 
     ELSE 0 END AS bloody_stool,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%altered mental status%') OR 
          UPPER (chiefcomplaint) LIKE UPPER('%Confusion%') THEN 1      
	 ELSE 0 END AS altered_mental_status,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%headache%') OR
          UPPER (chiefcomplaint) LIKE UPPER ('%HA%') THEN 1 
     ELSE 0 END AS headache,
CASE WHEN UPPER (chiefcomplaint) LIKE UPPER ('%vomit%') OR 
          UPPER (chiefcomplaint) LIKE UPPER('%N/V/D%') OR 
          UPPER (chiefcomplaint) LIKE UPPER('%N/V%')  THEN 1 
     ELSE 0 END AS vomit

FROM `physionet-data.mimic_ed.triage` cheif 
INNER JOIN `physionet-data.mimic_ed.edstays` edstay 
ON edstay.stay_id=cheif.stay_id
WHERE chiefcomplaint IS NOT NULL
),
