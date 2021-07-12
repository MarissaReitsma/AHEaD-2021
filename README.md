# AHEaD-2021
**Algorithmic Fairness in Population Health**

*Faculty Mentor*: Sherri Rose, [sherrirose@stanford.edu](mailto:sherrirose@stanford.edu) </br>
*Graduate Student Mentor*: Checo Gonzales, [checo@stanford.edu](mailto:checo@stanford.edu)

## Table of contents
- [Week 1](#week-1)
- [Week 2](#week-2)
- [Week 3](#week-3)
- [Week 4](#week-4)

## Project description

Gender minority individuals, transgender and gender diverse people whose gender
identity differs from their sex assigned at birth, have unique and often
profoundly challenging experiences navigating health care systems. They face
inequities in access to high-quality, affordable health care and in their
health outcomes. Representing the experiences of transgender and gender diverse
individuals at a population level is difficult as their gender identity is not
accurately captured in many large health databases and few principled methods
exist for identifying gender minority individuals in available data. These
issues halt large-scale downstream analyses that inform health policy. There is
a growing body of literature on these topics, providing an opportunity to
improve health inequalities, but more work is needed.

Over the summer, AHEaD scholars can help make progress on issues of health
equity for gender minorities by working on one or more of the following: 
- Review and critique existing literature that studies relationships between
  gender minority status and health-related variables 
- Review and critique existing literature that attempts to estimate the size of
  the gender minority community
- Characterize existing methods of representing gender minorities in data and
  identify to what extent findings can be used in meta-analyses 
- Develop queries and rules-based algorithms that identify gender minorities in
  Stanford's electronic health records (EHR) database 
- Develop machine learning algorithms that identify gender minorities using EHR

**Readings**
- Chen IY, Pierson E, Rose S, Joshi S, Ferryman K, Ghassemi M. Ethical Machine
  Learning in Healthcare. Annual Review of Biomedical Data Science. 2020;4.
*This article is lengthy and has technical jargon. We don’t expect you to
understand everything, but are using this paper to help give an overview of
fairness and ethics considerations in health care such that we can define the
scope of a project that will interest you. Focus on the big picture and bring
your questions to Tuesday’s meeting! :)*


## Week 1

Understanding data and health issues of gender diverse people

**Readings** 
- Conard, L. E. Supporting and Caring for Transgender and Gender Nonconforming
  Youth in the Urology Practice. Journal of Pediatric Urology 13, no. 3 (June
1, 2017): 300–304. https://doi.org/10.1016/j.jpurol.2017.02.019.
- Deutsch, Madeline B. Making It Count: Improving Estimates of the Size of
  Transgender and Gender Nonconforming Populations. LGBT Health 3, no. 3 (June
1, 2016): 181–85. https://doi.org/10.1089/lgbt.2016.0013.
- Sherman, Athena D. F., Kristen D. Clark, Kelley Robinson, Tara Noorani, and
  Tonia Poteat. Trans\* Community Connection, Health, and Wellbeing: A
Systematic Review. LGBT Health 7, no. 1 (January 2020): 1–14.
https://doi.org/10.1089/lgbt.2019.0014.
- Lehmann, Katrin, and Gerard Leavey. Accuracy of Psychometric Tools in the
  Assessment of Personality in Adolescents and Adults Requesting
Gender-Affirming Treatments: A Systematic Review. European Psychiatry : The
Journal of the Association of European Psychiatrists 62 (October 2019): 60–67.
https://doi.org/10.1016/j.eurpsy.2019.09.004.
- Kcomt, Luisa. Profound Health-Care Discrimination Experienced by Transgender
  People: Rapid Systematic Review. Social Work in Health Care 58, no. 2
(February 2019): 201–19. https://doi.org/10.1080/00981389.2018.1532941.
- McDowell A, Progovac AM, Cook BL, Rose S. Estimating the health status of
  privately insured gender minority children and adults. LGBT Health.
2019;6(6):289-96. https://doi.org/10.1089/lgbt.2018.0238. 

**Tasks**
- Complete trainings in Canvas

## Week 2
Getting started with coding, modeling, and literature reviews

**Readings**
- *Introduction to Statistical Learning*. Available free: 
  https://statlearning.com
  - 2.1-2.2 (Background)
  - 3.1-3.2 (Linear regression)
  - 4.1-4.3 (Classification/logistic regression)
  - 5.1 (Cross-Validation)

**Tasks**
- Install the [R programming Language](https://cran.r-project.org) and 
  optionally [R Studio](https://www.rstudio.org/)
- Work through this exercise in [Machine Learning](Machine-Learning)
- Fill out this [when2meet](https://www.when2meet.com/?12221510-ghnwH) to find
  a time to work on STARR onboarding with Checo
- Conduct a Literature Review using the Nation Library of Medicine's
  [MeSH](https://www.ncbi.nlm.nih.gov/mesh) terms and
  [PubMed](https://www.ncbi.nlm.nih.gov/mesh)
  - Find 8-10 articles that address how gender minorities can be found in 
    (health care) data and write a paragraph or more summarizing the articles
    keeping in mind the issues of gender identity & representation from the 
    readings [Week 1](#week-1)
  - Try to use git to create a 
    [pull request](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests)
    to add your `.bib` (bibTex) files of the articles you found and a `.md` 
    (Markdown) file of your summary to the [Lit-Review](Lit-Review) folder. If 
    this is new/challenging for you, try to figure it out on your own but don't
    spend too much time Checo can easily help! 

**MeSH Terms**
| Gender and Sex Concepts	|	Data Concepts		 |
| ----------------------------- | ------------------------------ |
| Transgender Persons		| Data, Factual			 |
| Gender Identity		| Data Science			 |
| Sex Factors			| Classification		 |
| Gender Dysphoria		| Electronic Health Records	 |
| Disorders of Sex Development	| 				 |

The above are some suggested MeSH terms to get you started. You might also want
to explore others and experiment to see the full power of MeSH.

## Week 3

**Readings**
- Morris, T. P., White, I. R., & Crowther, M. J. (2019). Using simulation studies to evaluate statistical methods. Statistics in medicine, 38(11), 2074-2102. https://doi.org/10.1002/sim.8086
- Zink, A., & Rose, S. (2020). Fair regression for health care spending. Biometrics, 76(3), 973-982. https://doi.org/10.1111/biom.13206

**Tasks**
- Complete STARR onboarding with Checo
- Get started on querying with Checo
- Work through simulation code from [fair regression](https://github.com/zinka88/Fair-Regression) repository, i.e., run_simulation.R and associated files.

## Week 4

**Readings**
- Good and bad practices
  - *Checo will add soon*
- Summarization methods
  - [Introduction to Modern Statistics](https://openintro-ims.netlify.app/index.html) (Chapters 4, 5, & 6)
  - [R for Data Science](https://r4ds.had.co.nz/) (Chapter 7)

**Tasks**
- Develop queries to extract patients who likely identify as a gender minority 
  from STARR and summarize findings. See the STARR section of the [Google 
  Cloud](./Google-Cloud) tutorial.
- Time to develop a simulation! In our previous code, the simulations were 
already created. Now we want to generate our own data that are inspired by the
STARR data. As you read in last weeks article on simulation studies,
simulations are an essential component in health research and part of many
research papers. They allow us to generate a world where we know the underlying
truth. Thus, we can test the performance of methods as well as create data
sources that area easily shareable when our real data have restricted access.
In the [Machine Learning](Machine-Learning) exercise, there were 2 uniform
independent variables (covariates) W1 and W2 and 1 binary outcome that was
generated based on W1 and W2. Real-world data is more complex, both in the
number of variables and the relationships between them. Your assignment is to
create a simplified simulated data set loosley inspired by the STARR data.
Select 5 covariates to generate, where 1 is documented sex. When considering
how to structure variables, think about information loss. For example, age is
often recorded as a bounded continuous or discrete variable (e.g., 18, 19, 20,
21, etc). However, sometimes age is categorized into bins (e.g., 18-25). What
are the pros and cons of using categories? Your covariates can also depend on
each other. For example, if one of the covariates is a particular health
condition that occurs more frequently among older adults, that covariate could
be generated dependent on age. A 6th covariate should be a binary indicator for
gender minority status. What percent of the population should have gender
minority status? For the outcome, create a simulated variable for 1-year
mortality. When deciding which covariates to generate, think about what
variables you would want in order to generate a mortality variable. It is not
expected that the simulated data would replicate the complexity of the STARR
data, but rather provide a reference point for certain features like the size
of the data and kinds of variables as well as an opportunity to synthesize the
information you've learned to date on this project.

