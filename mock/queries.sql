create or replace function check_chronic_desease(patient integer)
 returns boolean as $$
begin
   IF exists (select p.patient_id, d.desease_category from "Deseases" as d
   inner join "Patient_Desease" as pd using(desease_id)
   inner join "Patients" as p using(patient_id) 
   where p.patient_id = patient and d.desease_category like '%Chronic%')
    THEN return TRUE;
    ELSE
    return FALSE;
    END IF;
end;
$$ LANGUAGE plpgsql;