-- --------------------------------------------------------------------------------------------------------------------------------------------
-- This query extracts information matches JI program information;
-- It is the same order as to provide machine learning validation;
-- Note here coalesce() function was used to make sure vital signs are as first as possiable;
-- --------------------------------------------------------------------------------------------------------------------------------------------



SELECT 
age,
chest_pain,
abdominal_pain,
chest_tightness,
dyspnea,
fever,
syncope,
fatigue,
palpitation,
Hematemesis,	 
bloody_stool,
altered_mental_status,
headache,
vomit,
TRAUMA_YN,
DISCH_DX_RESP,
DISCH_DX_INJURY,
DISCH_DX_NEOPLASMS,
Cancer_Therapy,
ACTIVE_MALIGNANCY,
Hematologic_cancer,
metastatic_solid_tumor,
DISCH_DX_ABNORMAL_NOS,
cerebrovascular_disease,
DISCH_DX_FLU_PNEUMONIA,
DISCH_DX_CHRONIC_LOWER_RESP,
DISCH_DX_CIRC_DISEASE,
chronic_heart_failureIV,
DISCH_DX_DIGESTIVE_DISEASE,
Cirrhosis,
DISCH_DX_GU_DISEASE,
DISCH_DX_OTHER_DISEASE,
STEROID_THERAPY,
DISCH_DX_AIDS,
in_hospital_infection,
Use_Vasoactive_Drugs,
Planed_Admit_ERD,
arrhythmia,
Hypovolemic_hemorrhagic_shock,
Hypovolemic_non_hemorrhagic_shock,
Septic_shock,
Anaphylactic_shock,
Mix_shock,
Liver_failure,
Seizures,
coma,
stupor,
obtunded,
Agitation,
Vigilance_disturbance,
Confusion,
Focal_neurologic_deficit,
Intracranial_effect,
Acute_Abdomen,
SAP,
gcs,
coalesce(resprate,resp_rate) AS first_resprate,
coalesce(heartrate,heart_rate) AS first_heartrate,
coalesce(bloodpressure, sbp) AS first_sbp,
coalesce(o2sat,so2) AS first_o2sat,
fio2,
O2_DEVICE_FIRST,
o2_flow,
ph,
po2,
wbc,
Creatinine,
potassium,
sodium,
bun,
Glucose,
Hemoglobin,
platelet,
bilirubin_total,
(coalesce(heartrate,heart_rate)) / (coalesce(sbp,sbp)) AS xiuke_first,
alive_7day,
FROM stag_3 
WHERE time_interval=1 and chart_order_final=1
AND 
admission_age IS NOT NULL AND 
O2_DEVICE_FIRST IS NOT NULL	AND 
ph IS NOT NULL	AND 
po2	IS NOT NULL AND 
fio2 IS NOT NULL AND 
wbc IS NOT NULL AND	
Creatinine IS NOT NULL AND 
potassium IS NOT NULL AND 	
sodium IS NOT NULL AND 
bun IS NOT NULL AND 
Glucose	IS NOT NULL AND 
Hemoglobin	IS NOT NULL AND 
platelet IS NOT NULL AND 
bilirubin_total	IS NOT NULL AND 
xiuke_first IS NOT NULL AND 
gcs IS NOT NULL AND 
coalesce(o2sat,so2) IS NOT NULL AND
o2_flow IS NOT NULL
