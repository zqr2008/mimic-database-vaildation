-- ------------------------------------------------------------------
-- This query extracts comorbidity based on the recorded ICD-9 and ICD-10 codes.
-- JI program comorbidities are the desired list.
-- ------------------------------------------------------------------

diag AS
(
SELECT 
hadm_id, 
         CASE WHEN icd_version = 9 THEN icd_code ELSE NULL END AS icd9_code,
         CASE WHEN icd_version = 10 THEN icd_code ELSE NULL END AS icd10_code
    FROM `physionet-data.mimic_hosp.diagnoses_icd` diag
), 


com AS
(
SELECT
ad.hadm_id,

        -- TRAUMA_YN
         MAX(CASE WHEN
            SUBSTR(icd9_code, 1, 3) IN ('959')
            OR
            SUBSTR(icd10_code,1, 4) IN ('T149','T148')
            THEN 1 
            ELSE 0 END) AS TRAUMA_YN,

        -- DISCH_DX_RESP
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN'460' AND '519'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'J00' AND 'J99'
            THEN 1 
            ELSE 0 END) AS DISCH_DX_RESP, 

        -- DISCH_DX_INJURY
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3)  BETWEEN 'E00' AND 'E99'
            OR
            icd10_code LIKE 'S%'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'V00' AND 'V99' OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'W01' AND 'W99' OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'X01' AND 'X99' OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'Y01' AND 'Y99' 
            THEN 1 
            ELSE 0 END) AS DISCH_DX_INJURY,

        -- DISCH_DX_NEOPLASMS
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '140' AND '172'
            OR
            SUBSTR(icd9_code, 1, 4) BETWEEN '1740' AND '1958'
            OR
            SUBSTR(icd9_code, 1, 3) BETWEEN '200' AND '208'
            OR
            SUBSTR(icd9_code, 1, 4) = '2386'
            OR
            SUBSTR(icd10_code, 1, 3) IN ('C43','C88')
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C00' AND 'C26'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C30' AND 'C34'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C37' AND 'C41'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C45' AND 'C58'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C60' AND 'C76'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C81' AND 'C85'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'C90' AND 'C97'
            THEN 1 
            ELSE 0 END) AS DISCH_DX_NEOPLASMS,
        
        -- Cancer_Therapy
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('V580')
            OR 
            SUBSTR(icd9_code, 1, 5) IN ('V5811','V5812')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('Z510','Z511')
            THEN 1 
            ELSE 0 END) AS Cancer_Therapy,
            

        -- ACTIVE_MALIGNANCY(It is hard to tell active by icd_code,so it is coded same as
        -- 'Metastatic solid tumor')
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) IN ('196','197','198','199')
            OR 
            SUBSTR(icd10_code, 1, 3) IN ('C77','C78','C79','C80')
            THEN 1 
            ELSE 0 END) AS ACTIVE_MALIGNANCY,

        
        -- Hematologic cancer
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '200' AND '208'
            OR 
            SUBSTR(icd10_code, 1, 3) IN ('C81','C82','C83','C84','C85','C86','C88',
            'C90','C91','C92','C93','C94','C95','C96')
            THEN 1 
            ELSE 0 END) AS Hematologic_cancer,
        
        -- Metastatic solid tumor
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) IN ('196','197','198','199')
            OR 
            SUBSTR(icd10_code, 1, 3) IN ('C77','C78','C79','C80')
            THEN 1 
            ELSE 0 END) AS metastatic_solid_tumor,

        -- DISCH_DX_ABNORMAL_NOS
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) IN ('796')
            OR 
            SUBSTR(icd10_code, 1, 3) BETWEEN 'R00' AND 'R99'
            THEN 1 
            ELSE 0 END) AS DISCH_DX_ABNORMAL_NOS,

        -- Cerebrovascular disease
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '430' AND '438'
            OR
            SUBSTR(icd9_code, 1, 5) = '36234'
            OR
            SUBSTR(icd10_code, 1, 3) IN ('G45','G46')
            OR 
            SUBSTR(icd10_code, 1, 3) BETWEEN 'I60' AND 'I69'
            OR
            SUBSTR(icd10_code, 1, 4) = 'H340'
            THEN 1 
            ELSE 0 END) AS cerebrovascular_disease,
        
        -- DISCH_DX_FLU_PNEUMONIA
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '480' AND '488'
            OR 
            SUBSTR(icd10_code, 1, 3) IN ('J09','J10','J11','J12','J13','J14','J15','J16'
            ,'J17','J18')
            THEN 1 
            ELSE 0 END) AS DISCH_DX_FLU_PNEUMONIA,

        -- DISCH_DX_CHRONIC_LOWER_RESP(CHRONIC_LOWER_RESP adopted concept of Charlson Comorbidity Index 
        -- of chronic pulmonary disease)
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '490' AND '505'
            OR
            SUBSTR(icd9_code, 1, 4) IN ('4168','4169','5064','5081','5088')
            OR 
            SUBSTR(icd10_code, 1, 3) BETWEEN 'J40' AND 'J47'
            OR 
            SUBSTR(icd10_code, 1, 3) BETWEEN 'J60' AND 'J67'
            OR
            SUBSTR(icd10_code, 1, 4) IN ('I278','I279','J684','J701','J703')
            THEN 1 
            ELSE 0 END) AS DISCH_DX_CHRONIC_LOWER_RESP,


        -- DISCH_DX_CIRC_DISEASE(Diseases of the circulatory system (excluding
        -- cerebrovascular diseases (430-438,I60‐I69))
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '390' AND '459'
            AND 
            SUBSTR(icd9_code, 1, 3) NOT IN ('430','431','432','433','434','435','436','437'
            ,'438')
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'I00' AND 'I99'
            AND 
            SUBSTR(icd10_code, 1, 3) NOT IN ('I60','I61','I62','I63','I64','I65','I66','I67'
            ,'I68','I69')
            THEN 1 
            ELSE 0 END) AS DISCH_DX_CIRC_DISEASE,

        -- chronic heart failureIV
        -- ICD code do not have details for NYHA grade, so all chronic heart failure is labelled
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) IN ('428')
            OR
            SUBSTR(icd10_code, 1, 3) IN ('I50')
            THEN 1 
            ELSE 0 END) AS chronic_heart_failureIV,

        -- DISCH_DX_DIGESTIVE_DISEASE
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '520' AND '579'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'K00' AND 'K93'
            THEN 1 
            ELSE 0 END) AS DISCH_DX_DIGESTIVE_DISEASE,

        -- Cirrhosis
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('5712','5715','5716')
            OR
            SUBSTR(icd10_code, 1, 3) IN ('K74')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('K703')
            OR
            SUBSTR(icd10_code, 1, 5) IN ('P7881')
            THEN 1 
            ELSE 0 END) AS Cirrhosis,

        -- DISCH_DX_GU_DISEASE
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) BETWEEN '580' AND '629'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'N00' AND 'N99'
            THEN 1
            ELSE 0 END) AS DISCH_DX_GU_DISEASE,


        -- DISCH_DX_OTHER_DISEASE(icd9_code do not have a corresponding like icd10_code )
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) = '290'
            OR
            SUBSTR(icd9_code, 1, 4) IN ('2941','3312')
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'Q00' AND 'Q99'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'D50' AND 'D89'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'E00' AND 'E90'
            OR
            SUBSTR(icd10_code, 1, 3) BETWEEN 'F00' AND 'F99'
            THEN 1 
            ELSE 0 END) AS DISCH_DX_OTHER_DISEASE,


        -- STEROID_THERAPY
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('V5865')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('Z795')
            THEN 1 
            ELSE 0 END) AS STEROID_THERAPY,

        -- DISCH_DX_AIDS
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) IN ('042','043','044')
            OR 
            SUBSTR(icd10_code, 1, 3) IN ('B20','B21','B22','B24')
            THEN 1 
            ELSE 0 END) AS DISCH_DX_AIDS,

        --Shock code is referred to the following:
        --Hunley C, Murphy S M E, Bershad M, et al. 
        --Utilization of Medical Codes for Hypotension in Shock Patients: 
        --A Retrospective Analysis[J]. Journal of Multidisciplinary Healthcare, 2021, 14: 861.
        
        
        --Hypovolemic_hemorrhagic_shock
        
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('78559')
            OR 
            SUBSTR(icd10_code, 1, 4) IN ('R571')
            THEN 1 
            ELSE 0 END) AS Hypovolemic_hemorrhagic_shock,
        
        --Hypovolemic_non-hemorrhagic_shock
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('78550')
            OR 
            SUBSTR(icd10_code, 1, 4) IN ('R578','R579')
            THEN 1 
            ELSE 0 END) AS Hypovolemic_non_hemorrhagic_shock,

        --Septic_shock
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('78552')
            OR 
            SUBSTR(icd10_code, 1, 5) IN ('R6521')
            THEN 1 
            ELSE 0 END) AS Septic_shock,
        
        --Anaphylactic_shock
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('9950')
            OR 
            SUBSTR(icd10_code, 1, 4) IN ('T782')
            THEN 1 
            ELSE 0 END) AS Anaphylactic_shock,

        --Liver_failure
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('4560','4561','4562')
            OR
            SUBSTR(icd9_code, 1, 4) BETWEEN '5722' AND '5728'
            OR
            SUBSTR(icd10_code, 1, 4) IN ('I850','I859','I864','I982','K704','K711',
                                                   'K721','K729','K765','K766','K767')
            THEN 1 
            ELSE 0 END) AS Liver_failure,
                
        --Seizures
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('7803')
            OR
            SUBSTR(icd10_code, 1, 3) IN ('R56')
            THEN 1 
            ELSE 0 END) AS Seizures,
        
        --coma(GCS<8)
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('78001')
            OR
            SUBSTR(icd10_code, 1, 4) IN('R4020')
            OR
            SUBSTR(icd10_code, 1, 5) IN ('R40243','R40244')
            THEN 1 
            ELSE 0 END) AS coma,

        --stupor
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('78009')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('R401')
            THEN 1 
            ELSE 0 END) AS stupor,

        --obtunded(state similar to lethargy )
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('78079')
            OR
            SUBSTR(icd10_code, 1, 5) IN ('R5383')
            THEN 1 
            ELSE 0 END) AS obtunded,
        
        --Agitation
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('3079')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('R451')
            THEN 1 
            ELSE 0 END) AS Agitation,

        --Vigilance disturbance
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN ('79954')
            OR
            SUBSTR(icd10_code, 1, 6) IN ('R41843')
            THEN 1 
            ELSE 0 END) AS Vigilance_disturbance,
        
        --Confusion
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 5) IN  ('2982')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('R410')
            THEN 1 
            ELSE 0 END) AS Confusion,
        
        --Focal_neurologic_deficit
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 3) IN ('433','434','436')
            OR
            SUBSTR(icd9_code, 1, 3) IN ('430','431','432')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('F444')
            THEN 1 
            ELSE 0 END) AS Focal_neurologic_deficit,
        
        --Intracranial_effect(Compression of brain)
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('3484')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('G935')
            THEN 1 
            ELSE 0 END) AS Intracranial_effect,

        --Acute_Abdomen
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('7890')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('R100')
            THEN 1 
            ELSE 0 END) AS Acute_Abdomen,

        
        --SAP(severe is not graded here)
         MAX(CASE WHEN 
            SUBSTR(icd9_code, 1, 4) IN ('5770')
            OR
            SUBSTR(icd10_code, 1, 4) IN ('K859')
            THEN 1 
            ELSE 0 END) AS SAP,
        
   
  
FROM `physionet-data.mimic_core.admissions` ad
LEFT JOIN diag
ON ad.hadm_id = diag.hadm_id
GROUP BY ad.hadm_id
),
