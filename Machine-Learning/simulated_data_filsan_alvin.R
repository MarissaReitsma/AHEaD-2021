# Simulated Data_filsan_alvin

#######################################################################
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
# The DSM-5 estimates that about 0.005% to 0.014% of people assigned male at birth
# and 0.002% to 0.003% of people assigned female at birth are diagnosable with 
# gender dysphoria
#
# Prevalence of gender-affirming surgeries
# -> https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5977951
#
# Gender-affirming hormone therapies
# -> https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6354936/
#
# Homelessness among LGBT adults
# -> https://williamsinstitute.law.ucla.edu/wp-content/uploads/LGBT-Homelessness-May-2020.pdf
#
########################################################################


library(dplyr)

rm(list=ls())

n = 10000

# Create (n/2) values centered around 27 and 57, put directly into list
poisson_params = list( c(n/2, 27), c(n/2, 57))
ages = lapply(poisson_params, function(x) rpois(x[1], x[2])) %>% unlist()
ages
hist(ages)

surg_codes <- c("54520", "54690", "54125", "57335", "57291", "57292", "56805", 
                "58999", "19324", "19325", "31899")

# Simplify percentage of surgeries among trans community -> 13%
# >= 80% have taken gender affirming hormone therapy (GAHT) or want to at some point

trans_percentage <- 0.6   # (percentage of transgender individuals in the USA population) x 100
surg_percentage <- 0.13   # note that this is not amplified by ~x10
surg_probs <- trans_percentage*rep(surg_percentage/length(surg_codes), times=length(surg_codes))
surg_probs = 10*surg_probs


# Gender dysphoria probabilities amplified by ~100x
# Simplify data by assuming that surgeries and HRT's need individuals to be >= 18 y/0
# Depression in transgender individuals <65 y/0, more than 80% had depression

df2 = tibble(ages,
             sex = sample(c("M","F"), size=length(ages), replace=TRUE, prob=c(0.495,0.505)),
             dysph = if_else( sex == "M",
                                  sample(c(1,0), size=(length(ages)), replace=TRUE, prob=c(0.14,0.86)),
                                  sample(c(1,0), size=(length(ages)), replace=TRUE, prob=c(0.03,0.97)) ),
             surg = if_else(ages < 18, "NA",
                            if_else(dysph == 1, sample(c("NA",surg_codes), size=length(ages), replace=TRUE, 
                                                       prob = c(1-surg_probs[1], surg_probs) ),
                                    sample("NA", size=length(ages), replace=TRUE)
                                    )
                            ),
             test_estro = ifelse(ages >= 18 & dysph == 1,  
                                  sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.8,0.2)),
                                  sample(0, size=length(ages), replace=TRUE) ),
             depression = ifelse(ages >= 18 & dysph == 1, 
                                 sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.2,0.8)),
                                 sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.067,0.933)) ),
             employment = if_else(ages<18, 
               sample(0, size=length(ages), replace=TRUE),
               if_else(ages>=18 & dysph==1,
                       sample(c(1,0), size = length(ages), replace=TRUE, prob=c(0.75,0.25)),
                       sample(c(1,0), size = length(ages), replace=TRUE, prob=c(0.9633,0.0367)) )),
             housing = ifelse(ages >= 18 & dysph == 1,  
                              sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.92,0.08)),
                              sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.998,0.002)) )
)

df2             
print.data.frame(df2)


# Invert indicator variable values for gender dysphoria and depression
df2 = df2 %>% mutate(depr_invert = if_else(depression==1, 0, 1))
df2 = df2 %>% mutate(dysph_invert = if_else(dysph==1, 0, 1))

# Add survival covariate based on depression, employment, housing, and gender dysphoria              
df2 = df2 %>% mutate(survival_1yr = (depression + employment + housing + dysph_invert)/4 )
viewdf <- View(df2)

# mortality rate = (d/p)*(10^n)
# d -> deaths from cause of interest
# p -> size of population of interest, in which the deaths occur
# 10^n -> size of entire general population. 

df2 = df2 %>% mutate(mortality = (1-survival_1yr)*100)
