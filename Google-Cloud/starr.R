library("tidyverse")
library("bigrquery")
projectId = "mining-clinical-decisions"         # This shouldn't change
authPath  = "path/to/auth-key.json"             # Change this
bq_auth(authPath)

demographic_query = "SELECT 
                        *
                     FROM
                        starr_datalake2018.demographic
                     LIMIT
                        100;
                    "
demographic_table = bq_project_query(projectId, demographic_query) %>%
  bq_table_download()

hist_query = "SELECT
                DISTINCT rit_uid,
                CASE WHEN gender = 'Male' THEN 1 ELSE 0 END AS males,
		            CASE WHEN gender = 'Female' THEN 1 ELSE 0 END AS females,
        		    CASE WHEN canonical_race LIKE '%Asian%' THEN 1 ELSE 0 END AS asians,
		            CASE WHEN canonical_race LIKE '%Black%' THEN 1 ELSE 0 END AS blacks,    
	        	    CASE WHEN canonical_race LIKE '%Pacific%' THEN 1 ELSE 0 END AS pacific_islanders,
        		    CASE WHEN canonical_race LIKE '%White%' THEN 1 ELSE 0 END AS whites,
		            CASE WHEN canonical_race LIKE '%Other%' THEN 1 ELSE 0 END AS race_other,
        		    CASE WHEN canonical_race LIKE '%Unknown%' THEN 1 ELSE 0 END AS race_unknown,
		            CASE WHEN canonical_ethnicity LIKE 'Hispanic%' THEN 1 ELSE 0 END AS hispanic
              FROM
                starr_datalake2018.demographic
              WHERE rit_uid IN
              ( SELECT DISTINCT
                  jc_uid
                FROM 
                  starr_datalake2018.encounter
                WHERE appt_type = 'History'
                LIMIT 100
              )
             "
hist_table = bq_project_query(projectId, hist_query) %>%
  bq_table_download()

gender_dys_query = "SELECT
                      dem.rit_uid,
                      dem.gender,
                      dem.insurance_payor_name,
                      dx.icd10
                    FROM
                      starr_datalake2018.demographic as dem LEFT JOIN
                      starr_datalake2018.diagnosis_code as dx ON dem.rit_uid = jc_uid
                    WHERE dem.gender = 'Female'
                    AND dx.icd10 = 'F64.2'
                  "
gender_dys_table = bq_project_query(projectId, gender_dys_query) %>%
  bq_table_download()
gender_dys_table %>% mutate(public_insurance = ifelse(is.na(insurance_payor_name), NA, insurance_payor_name %in% c("MEDICAID", "MEDICARE"))) %>% 
    group_by(public_insurance) %>% 
    summarise(n = n())