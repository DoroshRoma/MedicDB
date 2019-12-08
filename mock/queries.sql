select "Clinics"."clinic_name", "Doctors"."surname" from "Clinics", "Doctor_Clinic", "Doctors"
where "Doctor_Clinic"."doctor_id" = "Doctor_Clinic"."clinic_id";
