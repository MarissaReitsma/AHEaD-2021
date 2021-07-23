# Simulated Data - Alvin

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

trans_percentage <- 0.6   # (percentage of transgender individuals in the USA population) x 10
surg_percentage <- 0.13   # note that this is not amplified by ~x10
surg_probs <- trans_percentage*rep(surg_percentage/length(surg_codes), times=11)

# Gender dysphoria probabilities amplified by ~10x
# Simplify data by assuming that surgeries and HRT's need individuals to be >= 18 y/0
# Depression in transgender individuals <65 y/0, more than 80% had depression

df2 = tibble(ages,
             sex = sample(c("M","F"), size=length(ages), replace=TRUE, prob=c(0.495,0.505)),
             dysph = if_else( sex == "M",
                                  sample(c(1,0), size=(length(ages)), replace=TRUE, prob=c(0.14,0.86)),
                                  sample(c(1,0), size=(length(ages)), replace=TRUE, prob=c(0.03,0.97)) ),
             surg = if_else(ages < 18, "NA", 
                            sample(c("NA",surg_codes), size=length(ages), replace=TRUE, 
                                   prob = c(1-surg_probs[1], surg_probs) )),
             test_estro = ifelse(ages >= 18 & dysph == 1,  
                                  sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.8,0.2)),
                                  sample(0, size=length(ages), replace=TRUE) ),
             depression = ifelse(ages >= 18 & dysph == 1, 
                                 sample(c(1,0), size=length(ages), replace=TRUE, prob=c(0.8,0.2)),
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

# Complete code for computing mortality based on depression, employment, housing statuses
# among individuals who experience gender dysphoria
