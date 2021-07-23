# STARR Data Training - Alvin
# Note to self: use VPN


#rm(list=ls())
getwd()
setwd("C:/Users/PierreAlvinGo/Downloads/")
getwd()

library("tidyverse")
library("bigrquery")

projectId = "mining-clinical-decisions"		    # This shouldn't change
authPath  = "C://Users//PierreAlvinGo//AppData//Roaming//gcloud//application_default_credentials.json"		    # Change this to your own path 
bq_auth(authPath)


# Test run
demographic_query = "SELECT 
			*
		     FROM
			starr_datalake2018.demographic
		     LIMIT
			100
		    " 
demographic_table = bq_project_query(projectId, demographic_query) %>%
  bq_table_download()
demographic_table


# Subquery 
# Look for distinct patients that were seen for a History appointment, and then
# create indicator variable for their assigned sex at birth and race/ethnicity
# rit_uid - unique identifier to patient. Found in lda sheet
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
hist_table


# Want to keep some variables from both tables instead of just conditioning on 
# another table. For that we can use a JOIN command or a merge operation. 
# With this query I'm going to try to find patients assigned Female at birth 
# who were diagnosed with Gender Dysphoria and I want to summarize how they are 
# insured but I want to use dplyr instead of SQL.
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
# icd10 -> gender dysphoria, 10-17 y/o
gender_dys_table = bq_project_query(projectId, gender_dys_query) %>%
  bq_table_download()
gender_dys_table %>% mutate(public_insurance = ifelse(is.na(insurance_payor_name), NA, insurance_payor_name %in% c("MEDICAID", "MEDICARE"))) %>% 
  group_by(public_insurance) %>% 
  summarise(n = n())


# National Drug Code Querying
# Androderm. Patch contains testosterone (transdermal system)
ndc_query = "SELECT 
			*
		     FROM
			starr_datalake2018.ndc_code
		     LIMIT
			100000000000000
		    " 
ndc_table = bq_project_query(projectId, ndc_query) %>%
  bq_table_download()
ndc_table

ndc_codes <- ndc_table$ndc_code

# Testosterone NDC codes
# https://www.findacode.com/ndc/drugs/TESTOSTERONE
test_ncd = c(
  "00591-2921", "00591-3216", "00591-4810", "00591-3217", 
  "00591-2114", "00591-3524", "00591-2363", "00591-2924", 
  "00591-2925", "00591-2926", "62332-0552", "62332-0488", 
  "71589-0011", "69238-1013", "57520-0638", "57520-0895", 
  "57520-0153", "63629-2124", "63629-2125", "63629-2352", 
  "63629-8455", "69097-0363", "43742-0021", "43742-0677", 
  "43742-1242", "43598-0304", "50845-0113", "68180-0943", 
  "68180-0941", "16714-0967", "16714-0968", "16714-0969", 
  "00603-7831", "49884-0418", "49884-0510", "00254-1012", 
  "45802-0116", "45802-0610", "45802-0754", "45802-0281", 
  "45802-0366", "66993-0934", "66993-0963", "43853-0005", 
  "43853-0021", "69761-0110", "69761-0120", "69761-0125", 
  "69761-0137", "69761-0150", "69761-0187", "70518-1171", 
  "24979-0078", "00832-1120", "00832-1121", "70700-0112", 
  "44117-0001", "44117-0002", "68382-0362")

# Count for presence of testosterone 
test_count = 0        # 
test_indices = c()    # vector of indices of individuals w/ testosterone therapies

# Loop through each entry in ndc_codes, and our testosterone codes of interest
for (i in (1:length(ndc_codes)) ){
  for (j in (1:length(test_ncd)) ){
    if (isTRUE(str_detect(ndc_codes[i], test_ncd[j])) == TRUE){
      print(i, ndc_codes[i])
      test_indices <- c(test_indices,i)
      test_count = test_count+1
    }
    j=j+1
  }
  i=i+1
}

# Note that there are too many manufacturers of TRT's that our test_ncd() does
# not include
# Similar for estrogen therapy as well. Vector of results is very limited. 
# Search returns null. Let us rethink this method





#######################################################################
# Procedure Code Query
#
# Coding for Gender Reassignment Surgery
# https://www.icd10monitor.com/coding-for-gender-reassignment-surgery
#
# Orchiectomy (54520, 54690)
# Penectomy (54125)
# Vaginoplasty (57335)
# Colovaginoplasty (57291-57292)
# Clitoroplasty (56805)
# Labiaplast(58999)
# Breast augmentation (19324-19325)
# Tracea shave/reduction thyroid chondroplasty (31899)
#
########################################################################

procedure_query = "SELECT 
			*
		     FROM
			starr_datalake2018.procedure_code
		     LIMIT
			100000
		    " 
procedure_table = bq_project_query(projectId, procedure_query) %>%
  bq_table_download()
procedure_table

#cpt_codes <- procedure_table$px_id
procedure_codes <- procedure_table$code

# Relevant CPT codes for common gender reassignment surgical procedures 
surg_codes <- c("54520", "54690", "54125", "57335", "57291", "57292", "56805", 
                     "58999", "19324", "19325", "31899")

# Count for surgical procedures
surg_count = 0            # counter for number of people w/ testosterone therapies
surg_indices = c()        # vector of indices of those w/ testosterone therapies

for (i in (1:length(procedure_codes)) ){
  for (j in (1:length(surg_codes)) ){
    if (procedure_codes[i] == surg_codes[j])
    {
      paste("procedure codes[i]: ", procedure_codes[i])
      paste("surg_codes[j]: ", surg_codes[j])
      surg_indices <- c(surg_indices,i)
      surg_count = surg_count+1
    }
    j=j+1
  }
  i=i+1
}

########################################################################
#
# Found 9 people (out of this 100,000 people sample) who underwent
# gender reassignment surgery
#
# > surg_count
# [1] 9
# > surg_indices
# [1] 24503 29351 43792 48940 54470 59841 59958 89203 94735
# > procedure_codes[surg_indices]
# [1] "19325" "31899" "58999" "54125" "19325" "58999" "58999" "31899" "19325"
#
########################################################################


# Work on fixing other broken query code and push to Github