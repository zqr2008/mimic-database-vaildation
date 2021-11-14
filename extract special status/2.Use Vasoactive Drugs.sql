-- ------------------------------------------------------------------
-- This query(Use_Vasoactive_Drugs_1) extracts whether the patient used vasoactive drugs(including dobutamine,dopamine,epinephrine
-- norepinephrine,phenylephrine,vasopressin)
-- ------------------------------------------------------------------



Use_Vasoactive_Drugs_1 AS
(SELECT * FROM(
SELECT 
subject_id, 
rate,
starttime,
endtime,
row_number() over (PARTITION by subject_id ORDER BY starttime) AS chart_order
FROM `physionet-data.mimic_icu.inputevents`
WHERE itemid IN (221653,   -- dobutamine
                 221662,   -- dopamine
                 221289,   -- epinephrine
                 221906,   -- norepinephrine
                 221749,   -- phenylephrine
                 222315)   -- vasopressin 
                  AND rate != 0 AND rate IS NOT NULL 
)WHERE chart_order=1
),

Use_Vasoactive_Drugs_2 AS
(
SELECT 
stag_1.subject_id,
    CASE WHEN rate IS NOT NULL AND starttime<= DATETIME_ADD(stag_1.admittime,  INTERVAL '6' hour)
    THEN 1 ELSE 0
    END AS Use_Vasoactive_Drugs

FROM Use_Vasoactive_Drugs_1
RIGHT JOIN stag_1 
ON stag_1.subject_id=Use_Vasoactive_Drugs_1.subject_id
),
