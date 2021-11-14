-- ------------------------------------------------------------------
-- This query extracts first ventilation status based on the mimic_derived.ventilation
-- Converted into O2_DEVICE_FIRST that match code in JI program 
-- O2_DEVICE_FIRST：
-- NASAL CANNULE:0   Oxygen
-- NONE(ROOM AIR):0
-- OXYGEN MASK:1
-- VENTILATOR:3  NonInvasiveVent;Trach;InvasiveVent
-- VENTURI MASK:2  HighFlow
-- ------------------------------------------------------------------

vent_1 AS
(SELECT * FROM
(SELECT 
stay_id,
starttime,
endtime,
ventilation_status,
row_number() over (PARTITION by stay_id ORDER BY starttime) AS chart_order
FROM `physionet-data.mimic_derived.ventilation` vent
)WHERE chart_order=1
),

vent_2 AS
(SELECT 
stag_1.subject_id  AS subject_id,

         CASE WHEN ventilation_status='Oxygen' 
         AND  starttime<= DATETIME_ADD(stag_1.admittime, INTERVAL '24' hour)
         THEN 0
         WHEN ventilation_status='HighFlow' 
         AND  starttime<= DATETIME_ADD(stag_1.admittime, INTERVAL '24' hour)
         THEN 2
         WHEN ventilation_status='Trach' 
         AND  starttime<= DATETIME_ADD(stag_1.admittime, INTERVAL '24' hour)
         THEN 3
         WHEN ventilation_status='NonInvasiveVent' 
         AND  starttime<= DATETIME_ADD(stag_1.admittime, INTERVAL '24' hour)
         THEN 3
         WHEN ventilation_status='InvasiveVent' 
         AND  starttime<= DATETIME_ADD(stag_1.admittime, INTERVAL '24' hour)
         THEN 3 
         ELSE 0 END AS O2_DEVICE_FIRST,

FROM vent_1
RIGHT JOIN stag_1 
ON stag_1.stay_id =vent_1.stay_id
),
