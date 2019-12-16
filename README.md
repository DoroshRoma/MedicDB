# MedicDB
This repo contains ER-diagram with some SQL queries to get data from medical card database.
## Entity Relatioship(ER) diagram
![ER-diagram](./img/ER_diagram.png)
## Tools
* Windows 10 version 1809
* PgAdmin 4 
* For creating ER-diagram https://www.lucidchart.com/
## Example of SQL queries
1. Select all doctors from database
```sql
select * from "Doctors";
```
| doctor_id |  surname  |   name   | patronymic |  doctor_spec    |
|-----------|-----------|----------|------------|----------------|
|         0 | Gleeton   | Reynard  | McCarry    | Therapist       |
|         1 | Patillo   | Dotty    | Laughtisse | Allergist       |
|         2 | Cragell   | Dav      | Talby      | Oncologist      |
|         3 | Routledge | Virginie | Kirkness   | Cardiologist    |
|         4 | Sire      | Kitty    | MacMychem  | Rheumatologist  |
2. Select clinic, name and surname of all doctors with name "Reynard"
```sql
select c.clinic_name, d.name, d.surname
from "Clinics" as c, "Doctors" as d "Doctor_Clinic" as dc 
where d.name = 'Reynard'
and dc.doctor_id = d.doctor_id
and dc.clinic_id = c.clinic_id;
```
|  clinic_name   |  name    | surname |
|----------------|----------|---------|
| Med-Atlant     | Reynard  | Gleeton |
| Oxford-Medical | Reynard  | Gleeton |
3. Count how much events where doctor prescribes "Atenolo" to the patients.
```sql
select count(h.event_id), event_description from "History" as h 
inner join "Prescriptions" as p on h.presc_id = p.presc_id 
where description like '%Atenolo%';
```
| count | event_description |
|-------|-------------------|
|     1 | High pressure case|
4. Select all events between 2019 year
```sql
select event_id, event_description from "History"
where "event_end" between '2019-01-01' and '2019-12-31';
```
| event_id | event_description  |
|----------|--------------------|
|        0 | Flu case           |
|        1 | Flu case           |
|        2 | Cancer case        |
|        3 | Cancer case        |
|        4 | High pressure case |
|        5 | Lyme allergie case |
5. Select all patients who have chronic or allergies deseases
```sql
select p.surname , p.name, d.desease_category from "Patients" as p 
inner join "Patient_Desease" as pd using(patient_id) 
inner join "Deseases" as d using(desease_id) 
where d.desease_category like any(array['%Chronic%', '%Allergie%']);
``` 
| surname  | name  | desease_category |
|----------|-------|------------------|
| Lautie   | Daron | Allergies        |
| Gradly   | Corey | Chronic          |
6. Create view to get data about documents and deseases which patient has
```sql 
create view patients_master as 
select p.surname, d.desease_name, doc.doc_description from "Patients" as p
inner join "Patient_Desease" as pd using(patient_id)
inner join "Deseases" as d using(desease_id)
inner join "Patient_Doc" as pdoc using(patient_id)
inner join "Documents" as doc on pdoc.document_id = doc.doc_id;
```
| surname  |    desease_name     | doc_description  |
|----------|---------------------|------------------|
| Lautie   | Lyme Desease        | Blood Analysis   |
| Gradly   | Asthma              | X-Ray            |
| Gradly   | High Blood Pressure | X-Ray            |
| Gradly   | Lung Cancer         | X-Ray            |
| Enrich   | Lung Cancer         | Glucose Analysis |
| Entwisle | Lung Cancer         | Urine analysis   |
| Entwisle | Flu                 | Urine analysis   |
7. Create function for check if patient has chronic desease;
```sql
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
``` 
```sql
select check_chronic_desease(1) # False
select check_chronic_desease(2) # True
```
