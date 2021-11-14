-- The aim of this query is to combine stag_1,comorbidities,intervention,lab result and special status into stag_2;
-- A new variable Mix_shock is created to represent more than 1 kind of shock here;



stag_2 AS 
(SELECT 
stag_1.subject_id AS subject_idd,
stag_1.admittime AS admittimee,
stag_1.*,
ad.*,
com.*,
vent_2.*,
oxygen_2.*,
fio2_3.*,
infection_2.*,
Use_Vasoactive_Drugs_2.*,
arrhythmia_2.*,

     CASE WHEN Hypovolemic_hemorrhagic_shock+Hypovolemic_non_hemorrhagic_shock+
     Septic_shock+Anaphylactic_shock>=2
     THEN 1 ELSE 0
     END AS Mix_shock,

FROM `physionet-data.mimic_core.admissions` ad
LEFT JOIN com
ON ad.hadm_id = com.hadm_id
INNER JOIN stag_1 
ON stag_1.hadm_id =com.hadm_id 
INNER JOIN vent_2 
ON stag_1.subject_id  =vent_2.subject_id
INNER JOIN oxygen_2  
ON stag_1.subject_id  =oxygen_2.subject_id
INNER JOIN fio2_3 
ON stag_1.subject_id  =fio2_3.subject_id
INNER JOIN infection_2 
ON stag_1.subject_id =infection_2.subject_id 
INNER JOIN Use_Vasoactive_Drugs_2
ON stag_1.subject_id=Use_Vasoactive_Drugs_2.subject_id
INNER JOIN arrhythmia_2 
ON stag_1.subject_id =arrhythmia_2.subject_id
),
