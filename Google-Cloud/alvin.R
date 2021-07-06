# Working with Google Cloud - Alvin

install.packages("tidyverse")
install.packages("devtools")
#devtools::install_github("rstats-db/bigrquery")   # had trouble w/ this version
devtools::install_github("r-dbi/bigrquery")

# The basic steps for using bigrquery are to:
# 0. Import the library
# 1. Declare Google Cloud Project ID and authentication key
# 2. Declare your SQL query as a string in R
# 3. Call execute your query and store it as a table


## Step 0
library("tidyverse")
library("bigrquery")


## Step 1
projectId <- "corded-layout-318905"
authKey   <- "C://Users//PierreAlvinGo//AppData//Roaming//gcloud//application_default_credentials.json"
bq_auth(authPath)


## Step 2
query <- "SELECT 
		county, EXTRACT(YEAR FROM date) AS year, SUM(sale_dollars) AS total_revenue
	  FROM
		`bigquery-public-data.iowa_liquor_sales.sales`
	  GROUP BY
		county, year
	  ORDER BY
		total_revenue DESC"


## Step 3
tb <- bq_project_query(projectId, query)
tb <- bq_table_download(tb)
tb    # Before cleaning, tb has 202 unique counties, 10 unique years (2012-2021) 


# Add column for upper-cased county names
tb$county_upper = toupper(tb$county)

# Add column for upper-cased (first letter of word only) county names
tb$county_first_upper = str_to_title(tb$county) 

## Consider Fixing: 
# -Cerro Gord -> Cerro Gordo
# -Obrien -> O'brien
# -Pottawatta -> Pottawattamie


# Plot total revenue vs year for each county
library(ggplot2)

revenue_year <- ggplot(tb, aes(x=year, y=total_revenue, group=county_first_upper, color=county_first_upper) ) + geom_line() + geom_point() + ggtitle("County Total Revenue vs Year") + xlab("Year") + ylab("Total Revenue") + labs(color = "County") + theme(plot.title = element_text(hjust = +0.5))
revenue_year







