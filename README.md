



## Background:
a major challenge to collaborative multicenter research in emergency critical care is the lack of validated tools to risk-adjust outcomes. The
absence of such tools is fundamental barrier to comparing outcomes at baseline and in response to experimental interventions at different
institutions due to potential difference in case mix. The overall goal of this research collaboration is to develop a clinical research platform
that will facilitate future multicenter interventional clinical trials in the emergency critical care setting. The specific goal of JI program
is to derive and validate a outcome predictive model for predicting 7-day mortality of patients treated.

## What we have done:
we built a predictive model call EIRAS using data in emergency department from China(2 large hospitals).
In the variable screening link of the EIRAS model, the research team specified a data collection plan after repeated discussions, made a unified
case report form, repeated discussions and unified data collection procedures. The setting of the research data collection content refers to the
variables included in the authoritative scores of foreign emergency medicine and critical care medicine (such as DAVROS, SAPS3 scores). Through
data collection and integration and data preprocessing operations, we have obtained a database containing 75 patient sign data with the survival
rate of emergency critical patients within seven days as the prediction target.
Critically ill patients have complex clinical data, many predictive variables, and complex interactions.In order to better measure the performance
of different machine learning methods applied to emergency critical patient risk prediction systems, we have introduced accuracy (ACC), sensitivity
(Sen), specificity (Spe), Jordan index and receiver operating characteristic curve (ROC) Area under the curve (AUC) These indicators are used to
measure the performance of each model. The final performance of the model is as follows:
![image](https://user-images.githubusercontent.com/73268508/141684023-dde6ba64-14f4-4782-9dcc-456c4955f987.png)


It is already published at https://www.nature.com/articles/s41598-020-77548-3


## What this repo do:
This repo extracts all 75 matching variables in mimic database, as to provide the vaildation of EIRAS,
Note that this extracting stragey is very different from what EIRAS extract, even we tried to make the concept as similar as possible, one major 
reson is that mimic focus on ICU stays, EIRAS focus on ED stays. Even when mimic research group published the mimic-ed,there is still few
information to extract. Most of variables had to be taken from icu core.

Even so, the performance is not all bad:
![output](https://user-images.githubusercontent.com/73268508/141684089-e91b246e-2efe-4b55-8997-3fd069408c12.png)


That shows EIRAS model is a reliable tool! 


## The following is the description of 75 variables:
-------------------------------------------------- ---------------------
#### Provide information description:
#### 1. The comment does not need to appear at the end.
#### 2. '-' represents a sub-question, which will only appear when the superior question selects "Yes", otherwise the default is "No".
#### 3. The final output is the probability of death within 7 days, whether it will die within 7 days, and predict the power.
-------------------------------------------------- ---------------------
###### Part One: Basic Information Except for the first question AGE, other symptom questions in this part are made into multiple-choice form, if not filled in, the default is 0
###### AGE: Age (years): (integer)
###### chest pain: whether there is chest pain: (yes: 1, no: 0)
###### abdominal pain: whether there is abdominal pain: (yes: 1, no: 0)
###### Chest tightness: Whether there is chest discomfort (tightening, etc.): (Yes: 1, No: 0)
###### dyspnea: Do you have breathing difficulties: (Yes: 1, No: 0)
###### fever: Is there any fever: (Yes: 1, No: 0)
###### syncope: Is there syncope: (Yes: 1, No: 0)
###### fatigue: whether there is fatigue: (yes: 1, no: 0)
###### palpitation: Is there any palpitations: (Yes: 1, No: 0)
###### Hematemesis: Is there hematemesis: (Yes: 1, No: 0)
###### Bloody stools: Is there hematemesis: (Yes: 1, No: 0)
###### Altered mental status: Is there any conscious change: (Yes: 1, No: 0)
###### headache: Do you have a headache: (Yes: 1, No: 0)
###### vomiting: Is there vomiting: (Yes: 1, No: 0)
-------------------------------------------------- ---------------------
###### Part 2: Diagnosis categories (including the past and this time) This part is made into a multiple-choice form, if not filled in, the default is 0
###### TRAUMA_YN: Whether there is trauma: (Yes: 1, No: 0)
###### DISCH_DX_RESP: Are there any respiratory diseases (except influenza, pneumonia and chronic respiratory diseases): (Yes: 1, No: 0)
###### DISCH_DX_INJURY: Whether there are diseases caused by external factors (including trauma, poisoning, heatstroke, drowning): (Yes: 1, No: 0)
###### DISCH_DX_NEOPLASMS: Is it a tumor: (Yes: 1, No: 0) # This title is the superior question of the following four questions#
###### -Cancer_Therapy: Whether to accept cancer treatment: (Yes: 1, No: 0)
###### -ACTIVE_MALIGNANCY: Whether it is an active tumor: (Yes: 1, No: 0)
###### -Hematologic cancer: Whether it is a blood system tumor: (Yes: 1, No: 0)
###### -Metastatic cancer: Whether there is metastatic cancer: (Yes: 1, No: 0)
###### DISCH_DX_ABNORMAL_NOS: Are there any abnormal symptoms, signs, laboratory abnormalities that cannot be classified into ICD codes (unclassified): (Yes: 1, No: 0)
###### DISCH_DX_CEREBROVASC: Is there a cerebrovascular disease: (Yes: 1, No: 0)
###### DISCH_DX_FLU_PNEUMONIA: Is there flu/pneumonia: (Yes: 1, No: 0)
###### DISCH_DX_CHRONIC_LOWER_RESP: Is there any chronic lower respiratory tract disease: (Yes: 1, No: 0)
###### DISCH_DX_CIRC_DISEASE: Is there a circulatory system disease: (Yes: 1, No: 0) This question is the superior question of the following 1 question
###### -chronic heart failure IV: Whether there is chronic heart failure (NYHA IV): (Yes: 1, No: 0)
###### DISCH_DX_DIGESTIVE_DISEASE: Is there a digestive system disease: (Yes: 1, No: 0) This question is the superior question of the following 1 question
###### -Cirrhosis: Is there cirrhosis of the liver: (Yes: 1, No: 0)
###### DISCH_DX_GU_DISEASE: Is there any genitourinary system disease: (Yes: 1, No: 0)
###### DISCH_DX_OTHER_DISEASE: Are there other diagnoses that cannot be classified: (Yes: 1, No: 0)
###### STEROID_THERAPY: Are you receiving hormone therapy: (Yes: 1, No: 0)
###### DISCH_DX_AIDS: Is there AIDS: (Yes: 1, No: 0)
###### Infection: Whether there is nosocomial infection: (Yes: 1, No: 0)
###### Use_Vasoactive_Drugs: Whether to use intravenous vasoactive drugs: (Yes: 1, No: 0)
###### Planed_Admit_ERD: Is there a plan to enter the rescue room or ICU: (Yes: 1, No: 0)
-------------------------------------------------- ---------------------
###### Part 3: Detailed diagnosis (the main reason for entering the rescue room or ICU) This part is made into a multiple-choice form, if not filled in, the default is 0
###### ?arrhythmia: Whether arrhythmia is the main reason for entering the emergency room: (Yes: 1, No: 0)
###### Hypovolemic_hemorrhagic_shock: Is hemorrhagic shock the main reason for entering the emergency room: (Yes: 1, No: 0)
###### Hypovolemic_non-hemorrhagic_shock: Whether non-hemorrhagic hypovolemic shock is the main reason for entering the emergency room: (Yes: 1, No: 0)
###### Septic_shock: Is septic shock the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Anaphylactic_shock: Is anaphylactic shock the main reason for entering the emergency room: (Yes: 1, No: 0)
###### Mix_shoch: Whether mixed or unfinished shock is the main reason for entering the emergency room: (Yes: 1, No: 0)
###### Live_failure: Whether liver failure is the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Seizures: Is epilepsy the main reason for entering the emergency room: (Yes: 1, No: 0)
###### coma: Whether the coma is the main reason for entering the rescue room: (Yes: 1, No: 0)
###### stupor: Is the main reason for entering the rescue room for being stupefied: (Yes: 1, No: 0)
###### obtunded: Is the slowness the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Agitation: Is irritability the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Vigilance disturbance: Is excessive excitement the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Confusion: Whether delirium is the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Focal_neurologic_deficit: Is focal dysfunction the main reason for entering the emergency room: (Yes: 1, No: 0)
###### Intracranial_effect: Whether the intracranial space effect is the main reason for entering the rescue room: (Yes: 1, No: 0)
###### Acute_Abdomen: Whether acute abdomen is the main reason for entering the emergency room: (Yes: 1, No: 0)
###### SAP: Is acute severe pancreatitis the main reason for entering the emergency room: (Yes: 1, No: 0)
-------------------------------------------------- ---------------------
###### Part Four: Physical Examination Data
###### GCS_FIRST: GCS score: (numerical)
###### RR_FIRST: Respiratory rate (unit times/min): (numerical type)
###### HR_FIRST: Heart rate (unit beats/min): (numerical type)
###### SBP_FIRST: systolic blood pressure (unit mmHg): (numerical type)
###### SpO2_FIRST: oxygen saturation (unit %): (numerical type)
###### FiO2_FIRST: oxygen absorption concentration (unit %): (numerical type)
###### O2_DEVICE_FIRST: oxygen supply device: (nasal catheter: 0, room air: 0, oxygen mask: 1, Venturi inner mask (or other high-flow oxygen inhalation device): 2, ventilator: 3)
###### O2_FLOW_RATE_FIRST: Oxygen flow rate (unit L/min): (numerical type)
-------------------------------------------------- ---------------------
###### Fifth Division###### Points: Laboratory Data
###### PH_FIRST: pH (pH): (numerical type)
###### PO2_FIRST: Oxygen partial pressure (PO2, unit mmHg): (numerical type)
###### WBC: White blood cell (WBC, unit 10^9/L): (numerical type)
###### CREATININE_UMOL/L: Creatinine (Cr, unit umol/L): (Numerical)
###### POTASSIUM: Serum potassium (K+, unit mmol/L): (numerical type)
###### SODIUM: blood sodium (K+, unit mmol/L): (numerical type)
###### BUN_MMOL/L: Urea nitrogen (BUN, unit mmol/L): (numerical type)
###### GLUCOSE: blood sugar (Glu, unit mmol/L): (numerical type)
###### HGB: Hemoglobin (Hgb, unit g/L): (numerical type)
###### PLT: Platelet (PLT, unit 10^9/L): (numerical type)
###### TBIL: total bilirubin (TBIL, umol/L): (numerical type)
###### xiuke_first: This item does not need to be filled in, it is automatically calculated, and the calculation formula is HR_FIRST/SBP_FIRST
-------------------------------------------------- --------------------- 
